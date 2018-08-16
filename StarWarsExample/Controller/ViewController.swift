//
//  ViewController.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 20/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var films : [Film] = []
    var searchResults : [Film] = []
    var searchController : UISearchController!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        //refreshControl.attributedTitle = NSAttributedString(string: "Updating Films...", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)])
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
    }()
    
    
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
        self.downloadFilmDataFromAPI()
        
        
    } // End - viewDidLoad
    
    
    // Ocultar menú superior
    func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh data
    
    @objc func refreshData() {
        
        // Limpiamos la tableView
        self.films.removeAll()
        tableView.reloadData()
        
        // Descargamos los datos de la API
        self.downloadFilmDataFromAPI()
        
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
        self.searchController.searchBar.placeholder = "Find film..."
        // Color del texto "Cancelar"
        self.searchController.searchBar.tintColor = UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        // Mostrar la barra de navegacion durante la búsqueda
        self.searchController.hidesNavigationBarDuringPresentation = false
        
    }
    

    
    
    // MARK: - Downloading film data from API
    
    func downloadFilmDataFromAPI() {
        
        // Comprobamos conexión a Internet para descargar los datos
        guard CheckInternet.isConnectedToNetwork() else {
            // Mostramos alerta de no conexión
            showAlert(vc: self, message: "Your device is not connected with internet")
            // Ocultamos la ruleta
            hideRefresher(refresher: refresher)
            return
        }
        
        // Si hay acceso a Internet...
        
        // Ejecutamos en segundo plano la descarga de los datos desde la API
        DispatchQueue.global().async {
            
            // Realizamos el recuento de objetos para el recurso de films
            getNumberOfObjects(nameResource: "films", arrayFilms : self.films) { getObject in
                
                // Si recibe el número de peliculas
                guard let numberOfObjects = getObject else {
                    // Si no las llega a recibir
                    print("Ocurrió un error")
                    return
                }
                
                getArrayOfFilms(numberOfFilms: numberOfObjects) { getFilm in
                    if let checkFilm = getFilm {
                        
                        // Enviamos al hilo principal las siguientes acciones
                        DispatchQueue.main.async {
                            
                            // Añadir nueva película al array
                            self.films += [checkFilm]
                            
                            // Reordenamos el array de Películas por orden de episodios
                            self.films.sort{ $0.episode < $1.episode}
                            
                            // Recargar la tableView en el hilo principal
                            self.tableView.reloadData()
                            
                        } // End - DispatchQueue.main.async
                        
                    } // End - if
                    
                } // End - getArrayOfFilms
                
            } // End - getNumberOfObjects
            
        } // End - DispatchQueue.global().async
        
    } // End - downloadFilmDataFromAPI()
    
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.searchResults.count
        } else {
            return self.films.count
        }
    }
    
    // Función para retornar el tamaño de la celda
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let film : Film
        if self.searchController.isActive{
            film = self.searchResults[indexPath.row]
        } else {
            film = self.films[indexPath.row]
        }
        
        let cellID = "filmCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FilmCell
        cell.thumbnailImageView.image = film.image
        cell.titleLabel.text = film.title
        cell.descriptionLabel.text = film.opening_crawl
        cell.releaseYearLabel.text = film.release_date
        
        cell.thumbnailImageView.layer.cornerRadius = 10.0
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("He seleccionado la fila \(indexPath.row)")
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilmDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                // Le pasamos el objeto
                let selectedFilm : Film
                if self.searchController.isActive{
                    selectedFilm = self.searchResults[indexPath.row]
                } else {
                    selectedFilm = self.self.films[indexPath.row]
                }
                
                //let selectedFilm = self.films[indexPath.row]
                let destinationViewController = segue.destination as! FilmDetail
                destinationViewController.film = selectedFilm
                // Ocultar pestañas en la siguiente ventana
                destinationViewController.hidesBottomBarWhenPushed = true
            }
        }
        // Ocultar barra de navegación al cambiar de ventana
        if (self.searchController.isActive){
            searchController.isActive = false
        }
    }
    
    // MARK: - Search Bar
    
    // Método para filtrar en la búsqueda
    func filterContentFor(textToSearch: String) {
        self.searchResults = self.films.filter({ (film) -> Bool in
            let titleToFind = film.title.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            return titleToFind != nil
        })
    }

}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterContentFor(textToSearch: searchText)
            self.tableView.reloadData()
        }
    }
}
