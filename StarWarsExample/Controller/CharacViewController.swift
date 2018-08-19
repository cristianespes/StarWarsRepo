//
//  CharacViewController.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 21/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class CharacViewController: UITableViewController {
    
    // Personajes del film
    var people : [Person] = []
    var searchResults : [Person] = []
    var searchController : UISearchController!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        //refreshControl.attributedTitle = NSAttributedString(string: "Updating Characters...", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)])
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
    }()
    
    // Crea el Activity Indicator
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Aplicamos la configuración inicial en la vista
        self.viewInitialConfiguration()
        
        // Asignar el control de refresco la página
        if #available(iOS 10.0, *) {
            // >= iOS 10
            tableView.refreshControl = self.refresher
        } else {
            // <= iOS 9 (Before iOS 10)
            tableView.addSubview(self.refresher)
        }
        
        // Descargar datos de las películas de la API
        self.downloadCharacterDataFromAPI()
        
        
    } // End - viewDidLoad
    
    // Ocultar menú superior
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Refresh data
    
    @objc func refreshData() {
        
        // Limpiamos la tableView
        self.people.removeAll()
        tableView.reloadData()
        
        // Descargamos los datos de la API
        self.downloadCharacterDataFromAPI()
        
        // Ocultamos la ruleta
        hideRefresher(refresher: refresher)
        
    }
    
    // MARK: - Initial Configuration of the View
    
    func viewInitialConfiguration() {
        
        // Asignamos título largo a la barra de navegación
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)]
            navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // Inicializamos la barra de búsqueda
        self.searchController = UISearchController(searchResultsController: nil)
        
        if #available(iOS 11.0, *) {
            // Asignamos el searchController a la barra de navegación
            navigationItem.searchController = self.searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            
            // Color del texto dentro del searchController
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)]
            
        } else {
            // Fallback on earlier versions
            
            // Asignamos el searchController a la cabecera de la tabla
            self.tableView.tableHeaderView = self.searchController.searchBar
            // Color de la barra de búsqueda
            self.searchController.searchBar.barTintColor = UIColor(red: 38.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1)
        }
        
        // Asignamos los métodos del delegado
        self.searchController.searchResultsUpdater = self
        // Controla el contenido que se difumina
        self.searchController.dimsBackgroundDuringPresentation = false
        // Texto de placeholder
        self.searchController.searchBar.placeholder = "Find character..."
        // Color del texto "Cancelar"
        self.searchController.searchBar.tintColor = UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        // Mostrar la barra de navegacion durante la búsqueda
        self.searchController.hidesNavigationBarDuringPresentation = false
        
    }
    
    
    // MARK: - Downloading character data from API
    
    func downloadCharacterDataFromAPI() {
        
        // Comprobamos conexión a Internet para descargar los datos
        guard CheckInternet.isConnectedToNetwork() else {
            // Mostramos alerta de no conexión
            showAlert(vc: self, message: "Your device is not connected with internet")
            // Ocultamos la ruleta
            hideRefresher(refresher: refresher)
            return
        }
        
        // Si hay acceso a Internet...
        
        // Iniciamos la animación de carga
        startActivityIndicator(activityIndicator: self.activityIndicator, view: self.view, tableView: self.tableView)
        
        // Ejecutamos en segundo plano la descarga de los datos desde la API
        DispatchQueue.global().async {
            
            // Realizamos el recuento de objetos para el recurso people de la API
            getNumberOfObjects(nameResource: "people", arrayPeople : self.people) { getObject in
                
                // Si recibe el número de peliculas
                guard let numberOfObjects = getObject else {
                    // Si no las llega a recibir
                    print("Ocurrió un error")
                    return
                }
                
                // Ejecutamos la función para obtener el array con todos los personajes
                getArrayOfCharacters(numberOfCharacters: numberOfObjects) { getCharacter, successCount in
                    
                    guard let checkCharacter = getCharacter else { return }
                        
                        // Añadir nuevo personaje al array
                        self.people += [checkCharacter]
                        
                        // Reordenamos el array de Personales por orden de episodios
                        self.people.sort{ $0.name < $1.name}
                    
                    guard let finalCount = successCount else { return }
                    
                    if finalCount == self.people.count {
                        // Enviamos al hilo principal las siguientes acciones
                        DispatchQueue.main.async {
                            
                            // Paramos la animación de carga
                            self.activityIndicator.stopAnimating()
                            
                            // Recargar la tableView en el hilo principal
                            self.tableView.reloadData()
                            
                        } // End - DispatchQueue
                    } // End - if
                    
                } // End - getArrayOfCharacters
                
            } // End - getNumberOfObjects
            
        } // End - DispatchQueue.global().async
        
    } // End - downloadCharacterDataFromAPI()
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.searchResults.count
        } else {
            return self.people.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person : Person
        if self.searchController.isActive{
            person = self.searchResults[indexPath.row]
        } else {
            person = self.people[indexPath.row]
        }
        
        let cellID = "Character2Cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CharacterCell
        cell.thumbnailImageView.image = person.image
        cell.nameLabel.text = person.name
        cell.genderLabel.text = person.gender
        cell.birthLabel.text = person.birth_year
        
        cell.thumbnailImageView.layer.cornerRadius = 10.0
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    // Función para retornar el tamaño de la celda
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                // Le pasamos el objeto
                let selectedPerson : Person
                if self.searchController.isActive{
                    selectedPerson = self.searchResults[indexPath.row]
                } else {
                    selectedPerson = self.people[indexPath.row]
                }
                //let selectedPerson = self.people[indexPath.row]
                let destinationViewController = segue.destination as! CharacterDetail
                destinationViewController.person = selectedPerson
                // Ocultar pestañas en la siguiente ventana
                destinationViewController.hidesBottomBarWhenPushed = true
            }
        }
        // Ocultar barra de navegación al cambiar de ventana
        if (self.searchController.isActive){
            searchController.isActive = false
        }
    }
    
    // Método para filtrar en la búsqueda
    func filterContentFor(textToSearch: String) {
        self.searchResults = self.people.filter({ (person) -> Bool in
            let personToFind = person.name.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            return personToFind != nil
        })
    }

} // End - class CharacViewController

extension CharacViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterContentFor(textToSearch: searchText)
            self.tableView.reloadData()
        }
    }
} // End - extension CharacViewController
