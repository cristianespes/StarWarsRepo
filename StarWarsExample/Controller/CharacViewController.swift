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
        self.searchController.searchBar.placeholder = "Find character..."
        // Color del texto
        //self.searchController.searchBar.tintColor = UIColor.blue
        // Color de la barra de búsqueda
        self.searchController.searchBar.barTintColor = UIColor(red: 38.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1)
        // Mostrar la barra de navegacion durante la búsqueda
        self.searchController.hidesNavigationBarDuringPresentation = false

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        // Realizamos el recuento de objetos para el recurso people de la API
        getNumberOfObjects(nameResource: "people", arrayPeople : people) { getObject in
            
            
            // Si recibe el número de peliculas
            guard let numberOfObjects = getObject else {
                // Si no las llega a recibir
                print("Ocurrió un error")
                return
            }
            
            
            // Ejecutamos la función para obtener el array con todos los personajes
            getArrayOfCharacters(numberOfCharacters: numberOfObjects) { getCharacter in
                
                guard let checkCharacter = getCharacter else { return }
                
                // Enviamos al hilo principal las siguientes acciones
                DispatchQueue.main.async {
                    
                    // Añadir nuevo personaje al array
                    self.people += [checkCharacter]
                    
                    // Reordenamos el array de Personales por orden de episodios
                    self.people.sort{ $0.name < $1.name}
                
                    // Recargar la tableView en el hilo principal
                   self.tableView.reloadData()
                }
                
            } // End - getArrayOfCharacters
            
        } // End - getNumberOfObjects
        
        
    } // End - viewDidLoad
    
    // Ocultar menú superior
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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

}

extension CharacViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterContentFor(textToSearch: searchText)
            self.tableView.reloadData()
        }
    }
}