//
//  FilmDetail.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 20/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class FilmDetail: UIViewController {

    // Contenido del film
    @IBOutlet var filmImageView: UIImageView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var yearText: UILabel!
    var film : Film!
    
    // Personajes del film
    var people : [Person] = []
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Actualizamos los objetos de la vista
        self.filmImageView.image = self.film.image
        self.titleText.text = self.film.title
        self.descriptionText.text = self.film.opening_crawl
        self.yearText.text = self.film.release_date
        
        // Título de la cabecera
        self.navigationItem.title = self.film.title
        
        // Anulamos el título largo de la cabecera en esta pantalla
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        // Texto descripcion no editable
        self.descriptionText.isEditable = false
        
        // Descargar datos de los personajes de la película seleccionada
        self.downloadCharacterDataOfTheFilmFromAPI()
        
    } // End - viewDidLoad
    
    // Título barra de navegación cuando aparezca la pantalla
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Título de la cabecera
        self.navigationItem.title = self.film.title
    }*/
    
    // Ocultar menú superior
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Downloading character data of the film from API
    
    func downloadCharacterDataOfTheFilmFromAPI() {
        
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
                getArrayOfCharacters(numberOfCharacters: numberOfObjects) { getCharacter in
                    guard let checkCharacter = getCharacter else { return }
                    
                    for value in checkCharacter.films {
                        
                        if value == self.film.url {
                            // print("La película es la \(value) y el episodio es \(self.film.episode)")
                            
                            // Enviamos al hilo principal las siguientes acciones
                            DispatchQueue.main.async {
                                
                                // Añadir nuevo personaje al array
                                self.people += [checkCharacter]
                                
                                // Reordenamos el array de Personales por orden de episodios
                                self.people.sort{ $0.name < $1.name}
                                
                                // Recargar la tableView en el hilo principal
                                self.tableView.reloadData()
                                
                            } // End - DispatchQueue.main.async
                            
                        } // End - if
                    }
                } // End - getArrayOfCharacters
                
            } // End - getNumberOfObjects
            
        } // End - DispatchQueue.global().async
        
    } // End - downloadCharacterDataOfTheFilmFromAPI()
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharacterDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                // Le pasamos el objeto
                let selectedPerson  = self.people[indexPath.row]
                
                let destinationViewController = segue.destination as! CharacterDetail
                destinationViewController.person = selectedPerson
                // Ocultar pestañas en la siguiente ventana
                //destinationViewController.hidesBottomBarWhenPushed = true
                // Texto del item de navegación (botón atrás)
                //self.navigationItem.title = "Back"
                
            }
        }
        
        if segue.identifier == "showImageDetail" {
            if let image = self.filmImageView {
                
                let destinationViewController = segue.destination as! ImageViewController
                destinationViewController.getImage = image
                // Ocultar pestañas en la siguiente ventana
                //destinationViewController.hidesBottomBarWhenPushed = true
                // Texto del item de navegación (botón atrás)
                //self.navigationItem.title = "Back"
            }
        }
    }
    
}

// Creamos una extensnión de la clase para aplicar los protocolos para la tableview
extension FilmDetail : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Characters of films
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.text = "Characters of the film"
        label.textColor = UIColor(red: 244.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        //label.font = label.font.withSize(25)
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        label.backgroundColor = UIColor.black
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        view.addSubview(label)
        
        return view
    }
    
    // Esté método va junto con el anterior: viewForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = self.people[indexPath.row]
        let cellID = "CharacterCell"
        
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}
