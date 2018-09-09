//
//  CharacterDetail.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 21/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class CharacterDetail: UIViewController {
    
    // Contenido del personaje
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var homeworld = "-"
    
    var person : Person!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Actualizamos los objetos de la vista
        self.characterImageView.image = self.person.image
        
        // Título de la cabecera
        self.title = self.person.name
        
        // Asingación del delegado
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Anulamos el título largo de la cabecera en esta pantalla
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        downloadPlanetDataOfTheCharacterFromAPI()
        
    } // End - viewDidLoad
    
    // Ocultar menú superior
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Downloading character data of the film from API
    
    func downloadPlanetDataOfTheCharacterFromAPI() {
        
        // Ejecutamos en segundo plano la descarga de los datos desde la API
        DispatchQueue.global().async {
            
            
            getArrayOfAllObjects(nameResource : "planets") {count, objects in
                if let objects = objects {
                    
                    let planetID = convertStringToInt(string: self.person.homeworld)
                    
                    if let planet = getPlanetsByID(id: planetID, result: objects) {
                        self.homeworld = planet.name
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    } // End - DispatchQueue
                }
            }
            
        } // End - DispatchQueue.global().async
        
        /*
        // Ejecutamos en segundo plano la descarga de los datos desde la API
        DispatchQueue.global().async {
            
            // Ejecutamos la función para obtener el array con todos los personaje
            getPlanetByID(value: convertStringToInt(string: self.person.homeworld))
            { getPlanet, successCount in
                
                guard let checkPlanet = getPlanet else { return }
                
                // Añadir nuevo personaje al array    
                self.homeworld = checkPlanet.name
                
                // Enviamos al hilo principal las siguientes acciones
                DispatchQueue.main.async {
                    
                    // Recargar la tableView en el hilo principal
                    self.tableView.reloadData()
                    
                } // End - DispatchQueue
                
            } // End - getArrayOfCharactersFromFilm
            
        } // End - DispatchQueue.global().async
        */
    } // End - downloadPlanetDataOfTheCharacterFromAPI()

} // End - class CharacterDetail


extension CharacterDetail: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 8
        case 1:
            return self.person.films.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharDetailCell", for: indexPath) as! CharDetailCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Gender"
                cell.valueLabel.text = self.person.gender
            case 1:
                cell.keyLabel.text = "Year of Birth"
                cell.valueLabel.text = self.person.birth_year
            case 2:
                cell.keyLabel.text = "Height"
                cell.valueLabel.text = self.person.height
            case 3:
                cell.keyLabel.text = "Mass"
                cell.valueLabel.text = self.person.mass
            case 4:
                cell.keyLabel.text = "Hair Color"
                cell.valueLabel.text = self.person.hair_color
            case 5:
                cell.keyLabel.text = "Skin Color"
                cell.valueLabel.text = self.person.skin_color
            case 6:
                cell.keyLabel.text = "Eye Color"
                cell.valueLabel.text = self.person.eye_color
            case 7:
                cell.keyLabel.text = "Homeworld"
                cell.valueLabel.text = self.homeworld
            default:
                break
            }
         
        case 1:
            cell.keyLabel.text = ""
            cell.valueLabel.text = setTitleByFilm(film: self.person.films[indexPath.row])
 
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title = ""
        
        switch section {
        case 1:
            title = "Films"
        default:
            break
        }
        
        return title
        
    }
    
} // End - Extension CharacterDetail
