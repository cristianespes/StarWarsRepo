//
//  PlanetDetail.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 22/8/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class PlanetDetail: UIViewController {
    
    @IBOutlet weak var planetImageView: UIImageView!
    @IBOutlet weak var planetTableView: UITableView!
    
    var planet : Planet!
    
    var residents : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.planetImageView.image = planet.image
        
        // Título de la cabecera
        self.title = self.planet.name
        
        // Asignamos delegados
        self.planetTableView.delegate = self
        self.planetTableView.dataSource = self
        
        // Anulamos el título largo de la cabecera en esta pantalla
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        // Elimina las líneas de las filas vacías
        planetTableView.tableFooterView = UIView()
        
        downloadCharacterDataOfThePlanetFromAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Downloading character data of the planet from API
    
    func downloadCharacterDataOfThePlanetFromAPI() {
        
        // Ejecutamos en segundo plano la descarga de los datos desde la API
        DispatchQueue.global().async {
            
            
            getArrayOfAllObjects(nameResource : "people") {count, objects in
                if let objects = objects {
                    
                     let people = getArrayOfCharactersFromPlanet(planet: self.planet, result: objects)
                    
                    people.forEach { self.residents += [$0.name] }
                    
                    DispatchQueue.main.async {
                        self.planetTableView.reloadData()
                    } // End - DispatchQueue
                }
            }
            
        } // End - DispatchQueue.global().async
        
    } // End - downloadCharacterDataOfThePlanetFromAPI()
    
    

} // End - class PlanetDetail

extension PlanetDetail: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 8
        case 1:
            return self.residents.count
        case 2:
            return self.planet.films.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetDetailCell", for: indexPath) as! PlanetDetailCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Rotation Period"
                cell.valueLabel.text = self.planet.rotation_period
            case 1:
                cell.keyLabel.text = "Orbital Period"
                cell.valueLabel.text = self.planet.orbital_period
            case 2:
                cell.keyLabel.text = "Diameter"
                cell.valueLabel.text = self.planet.diameter
            case 3:
                cell.keyLabel.text = "Climate"
                cell.valueLabel.text = self.planet.climate
            case 4:
                cell.keyLabel.text = "Gravity"
                cell.valueLabel.text = self.planet.gravity
            case 5:
                cell.keyLabel.text = "Terrain"
                cell.valueLabel.text = self.planet.terrain
            case 6:
                cell.keyLabel.text = "Water Surface"
                cell.valueLabel.text = self.planet.surface_water
            case 7:
                cell.keyLabel.text = "Population"
                cell.valueLabel.text = self.planet.population
            default:
                break
            }
        case 1:
            cell.keyLabel.text = ""
            cell.valueLabel.text = self.residents[indexPath.row]
        case 2:
            cell.keyLabel.text = ""
            cell.valueLabel.text = setTitleByFilm(film: self.planet.films[indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title = ""
        
        switch section {
        case 1:
            if self.planet.residents.count > 0 {
                title = "Residents"
            }
        case 2:
            title = "Films"
        default:
            break
        }
        
        return title
        
    }
    
} // End - extension PlanetDetail
