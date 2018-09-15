//
//  StarshipDetail.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 25/8/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class StarshipDetail: UIViewController {
    
    @IBOutlet weak var starshipImageView: UIImageView!
    @IBOutlet weak var starshipTableView: UITableView!
    
    var starship : Starship!
    
    var pilots : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.starshipImageView.image = starship.image
        
        // Título de la cabecera
        self.title = self.starship.name
        
        // Asignamos delegados
        self.starshipTableView.delegate = self
        self.starshipTableView.dataSource = self
        
        // Anulamos el título largo de la cabecera en esta pantalla
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        // Elimina las líneas de las filas vacías
        starshipTableView.tableFooterView = UIView()
        
        downloadCharacterDataOfTheStarshipFromAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Downloading character data of the film from API
    
    func downloadCharacterDataOfTheStarshipFromAPI() {
        
        // Ejecutamos en segundo plano la descarga de los datos desde la API
        DispatchQueue.global().async {
            
            
            getArrayOfAllObjects(nameResource : "people") {count, objects in
                if let objects = objects {
                    
                    let people = getArrayOfCharactersFromStarship(starship: self.starship, result: objects)
                    
                    people.forEach { self.pilots += [$0.name] }
                    
                    DispatchQueue.main.async {
                        self.starshipTableView.reloadData()
                    } // End - DispatchQueue
                }
            }
            
        } // End - DispatchQueue.global().async
        
    } // End - downloadCharacterDataOfTheStarshipFromAPI()

} // End - class StarshipDetail


extension StarshipDetail: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 12
        case 1:
            return self.pilots.count
        case 2:
            return self.starship.films.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarshipDetailCell", for: indexPath) as! StarshipDetailCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Model"
                cell.valueLabel.text = self.starship.model
            case 1:
                cell.keyLabel.text = "Manufacturer"
                cell.valueLabel.text = self.starship.manufacturer
            case 2:
                cell.keyLabel.text = "Cost in credits"
                cell.valueLabel.text = self.starship.cost_in_credits
            case 3:
                cell.keyLabel.text = "Length"
                cell.valueLabel.text = self.starship.length
            case 4:
                cell.keyLabel.text = "Max. Atm. Speed"
                cell.valueLabel.text = self.starship.max_atmosphering_speed
            case 5:
                cell.keyLabel.text = "Crew"
                cell.valueLabel.text = self.starship.crew
            case 6:
                cell.keyLabel.text = "Passengers"
                cell.valueLabel.text = self.starship.passengers
            case 7:
                cell.keyLabel.text = "Cargo Capacity"
                cell.valueLabel.text = self.starship.cargo_capacity
            case 8:
                cell.keyLabel.text = "Consumables"
                cell.valueLabel.text = self.starship.consumables
            case 9:
                cell.keyLabel.text = "Hyperdrive Rating"
                cell.valueLabel.text = self.starship.hyperdrive_rating
            case 10:
                cell.keyLabel.text = "MGLT"
                cell.valueLabel.text = self.starship.MGLT
            case 11:
                cell.keyLabel.text = "Starship Class"
                cell.valueLabel.text = self.starship.starship_class
            default:
                break
            }
        case 1:
            cell.keyLabel.text = ""
            cell.valueLabel.text = self.pilots[indexPath.row]
        case 2:
            cell.keyLabel.text = ""
            cell.valueLabel.text = setTitleByFilm(film: self.starship.films[indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title = ""
        
        switch section {
        case 1:
            if self.starship.pilots.count > 0 {
                title = "Pilots"
            }
        case 2:
            title = "Films"
        default:
            break
        }
        
        return title
        
    }
    
} // End - extension StarshipDetail
