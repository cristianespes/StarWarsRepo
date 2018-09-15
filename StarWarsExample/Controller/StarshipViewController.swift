//
//  StarshipViewController.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 25/8/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class StarshipViewController: UITableViewController {

    // Planetas del film
    var starships : [Starship] = []
    var searchResults : [Starship] = []
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
            self.tableView.refreshControl = self.refresher
        } else {
            // <= iOS 9 (Before iOS 10)
            self.tableView.addSubview(self.refresher)
        }
        
        // Elimina las líneas de las filas vacías
        tableView.tableFooterView = UIView()
        
        // Descargar datos de las películas de la API
        self.downloadStarshipDataFromAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh data
    
    @objc func refreshData() {
        
        // Limpiamos la tableView
        self.starships.removeAll()
        self.tableView.reloadData()
        
        // Descargamos los datos de la API
        self.downloadStarshipDataFromAPI()
        
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
        self.searchController.searchBar.placeholder = "Find starship..."
        // Color del texto "Cancelar"
        self.searchController.searchBar.tintColor = UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        // Mostrar la barra de navegacion durante la búsqueda
        self.searchController.hidesNavigationBarDuringPresentation = false
        
    }
    
    
    // MARK: - Downloading character data from API
    
    func downloadStarshipDataFromAPI() {
        
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
            
            getArrayOfAllObjects(nameResource : "starships") {count, objects in
                if let objects = objects {
                    self.starships = returnArrayOfAllStarshipsFromData(result: objects)
                    
                    DispatchQueue.main.async {
                        // Paramos la animación de carga
                        self.activityIndicator.stopAnimating()
                        
                        // Recargar la tableView en el hilo principal
                        self.tableView.reloadData()
                    } // End - DispatchQueue
                }
            }
            
        } // End - DispatchQueue.global().async
        
    } // End - downloadStarshipDataFromAPI()
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive && !searchBarIsEmpty() {
            return self.searchResults.count
        } else {
            return self.starships.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let starship : Starship
        
        if self.searchController.isActive && !searchBarIsEmpty() {
            starship = self.searchResults[indexPath.row]
        } else {
            starship = self.starships[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarshipCell", for: indexPath) as! StarshipCell
        
        cell.nameLabel.text = starship.name
        
        cell.thumbnailImageView.image = starship.image
        
        cell.thumbnailImageView.layer.cornerRadius = 5.0
        cell.thumbnailImageView.clipsToBounds = true
        
        // Añadir felcha en el lado derecho
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    // Función para retornar el tamaño de la celda
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStarshipDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                // Le pasamos el objeto
                let selectedStarship : Starship
                if self.searchController.isActive {
                    selectedStarship = self.searchResults[indexPath.row]
                } else {
                    selectedStarship = self.starships[indexPath.row]
                }
                
                let destinationViewController = segue.destination as! StarshipDetail
                destinationViewController.starship = selectedStarship
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
        self.searchResults = self.starships.filter({ (starship) -> Bool in
            let starshipToFind = starship.name.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            return starshipToFind != nil
        })
    }

} // End - class StarshipViewController


extension StarshipViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterContentFor(textToSearch: searchText)
            self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
} // End - extension StarshipViewController
