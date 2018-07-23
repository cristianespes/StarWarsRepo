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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inicializamos la barra de búsqueda
        self.searchController = UISearchController(searchResultsController: nil)
        self.tableView.tableHeaderView = self.searchController.searchBar
        // Asignamos los métodos del delegado
        self.searchController.searchResultsUpdater = self
        // Controla el contenido que se difumina
        self.searchController.dimsBackgroundDuringPresentation = false
        // Texto de placeholder
        self.searchController.searchBar.placeholder = "Find film..."
        // Color del texto
        //self.searchController.searchBar.tintColor = UIColor.blue
        // Color de la barra de búsqueda
        self.searchController.searchBar.barTintColor = UIColor(red: 38.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1)
        // Mostrar la barra de navegacion durante la búsqueda
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        
        // Realizamos el recuento de objetos para el recurso de films
        getNumberOfObjects(nameResource: "films", arrayFilms : films) { getObject in
            
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
                    }
                    
                }
            }
        }
 
        
    }
    
    // Ocultar menú superior
    func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
