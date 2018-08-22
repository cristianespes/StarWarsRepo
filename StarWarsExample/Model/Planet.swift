//
//  Planet.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 21/8/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import Foundation
import UIKit


class Planet {
    
    let name : String
    let rotation_period : String
    let orbital_period : String
    let diameter : String
    let climate : String
    let gravity : String
    let terrain : String
    let surface_water : String
    let population : String
    var image : UIImage
    var residents : [String]
    var films : [Int]
    
    init(name: String, rotation_period: String, orbital_period: String,  diameter: String, climate: String, gravity: String, terrain: String, surface_water: String, population: String, image: UIImage, residents: [String], films: [Int]) {
        self.name = name
        self.rotation_period = rotation_period
        self.orbital_period = orbital_period
        self.diameter = diameter
        self.climate = climate
        self.gravity = gravity
        self.terrain = terrain
        self.surface_water = surface_water
        self.population = population
        self.image = image
        self.residents = residents
        self.films = films
    }
} // End - class Planet


// ---------------------------------------------------------------------------------

// MARK: - Get JSON from StarWars API

func getArrayOfPlanets(numberOfPlanets : Int, completion: @escaping (Planet?, Int?) -> Void ) {
    
    var successCount = numberOfPlanets
    
    for value in 1...numberOfPlanets {
        
        let urlString = "https://swapi.co/api/planets/\(value)/?format=json"
        
        // Check that the URL we’ve provided is valid
        guard let urlRequest = URL(string: urlString) else {
            print("Error: cannot create URL")
            completion(nil, nil)
            return
        }
        
        
        // Then we need a URLSession to use to send the request
        let session = URLSession.shared
        
        // Then create the data task
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            // can't do print(response) since we don't have response
            
            // Check if any error exists
            if let error = error {
                print(error)
                successCount -= 1
                completion(nil, nil)
                return
            }
            
            guard let datos = data else {return}
            
            do {
                let dataPlanet = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Comprobación de que el objeto existe o no está vacío
                if let error = dataPlanet["detail"] as? String {
                    print("Error: Data \(value) \(error)")
                    // Retiramos al contador un objeto erroneo para que contabilice solo los exitosos
                    successCount -= 1
                    completion(nil, nil)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let name = (dataPlanet["name"] as! String).capitalizingFirstLetter()
                
                let rotation_period = (dataPlanet["rotation_period"] as! String) == "unknown" ? "-" : (dataPlanet["rotation_period"] as! String).capitalizingFirstLetter()
                let orbital_period = (dataPlanet["orbital_period"] as! String) == "unknown" ? "-" : dataPlanet["orbital_period"] as! String
                let diameter = (dataPlanet["diameter"] as! String) == "unknown" ? "-" : dataPlanet["diameter"] as! String
                let climate = (dataPlanet["climate"] as! String) == "unknown" ? "-" : (dataPlanet["climate"] as! String).capitalizingFirstLetter()
                let gravity = (dataPlanet["gravity"] as! String) == "unknown" || (dataPlanet["gravity"] as! String) == "N/A" ? "-" : dataPlanet["gravity"] as! String
                let terrain = (dataPlanet["terrain"] as! String) == "unknown" ? "-" : (dataPlanet["terrain"] as! String).capitalizingFirstLetter()
                let surface_water = (dataPlanet["surface_water"] as! String) == "unknown" ? "-" : dataPlanet["surface_water"] as! String
                let population = (dataPlanet["population"] as! String) == "unknown" ? "-" : dataPlanet["population"] as! String
                
                let image = #imageLiteral(resourceName: "planetIcon")
                
                // Extraemos el array de films de cada personaje y lo convertimos a Int
                let extractedFilms = dataPlanet["films"] as! [String]
                var films : [Int] = convertArrayStringToInt(arrayOfString: extractedFilms)
                films.sort{ $0 < $1}
                
                let extractedResidents = dataPlanet["residents"] as! [String]
                let auxResidents : [Int] = convertArrayStringToInt(arrayOfString: extractedResidents)
                let residents : [String] = convertArrayIntToString(arrayOfInt: auxResidents)
                
                // Almacenamos los valores obtenidos en una instancia de Planet
                let planet = Planet(name: name, rotation_period: rotation_period, orbital_period: orbital_period, diameter: diameter, climate: climate, gravity: gravity, terrain: terrain, surface_water: surface_water, population: population, image: image, residents: residents, films: films)
                
                completion(planet, successCount)
            } catch {
                successCount -= 1
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
    
} // End - getArrayOfPlanets

// ---------------------------------------------------------------------------------

// MARK: - Download Image from URL as per the planet name

func showPlanetFromUrl(planetName: String) -> String {
    
    switch planetName {
    case "Tatooine":
        return "https://www.universeguide.com/mobile/tatooine.jpg"
    case "Alderaan":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/4/4a/Alderaan.jpg/revision/latest/scale-to-width-down/350"
    case "Yavin IV":
        return "https://vignette.wikia.nocookie.net/starwars/images/d/d4/Yavin-4-SWCT.png/revision/latest/scale-to-width-down/350"
        
    case "Hoth":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/1/1d/Hoth_SWCT.png/revision/latest/scale-to-width-down/350"
    case "Dagobah":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/1/1c/Dagobah.jpg/revision/latest/scale-to-width-down/350"
    case "Bespin":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/2/2c/Bespin_EotECR.png/revision/latest/scale-to-width-down/350"
    case "Endor":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/e/e5/Endor-SWCT.png/revision/latest/scale-to-width-down/350"
    case "Naboo":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/5/50/Naboo.jpg/revision/latest/scale-to-width-down/350"
    case "Coruscant":
        return "https://vignette.wikia.nocookie.net/starwars/images/1/16/Coruscant-EotE.jpg/revision/latest/scale-to-width-down/350"
    case "Kamino":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/5/52/Kamino-DB.png/revision/latest/scale-to-width-down/350"
    case "Geonosis":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/6/6d/Geonosis_AotC.png/revision/latest/scale-to-width-down/350"
    case "Utapau":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/4/4f/Utapau.jpg/revision/latest/scale-to-width-down/350"
    case "Mustafar":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/b/b2/Mustafar_FFGRebellion.png/revision/latest/scale-to-width-down/350"
    case "Kashyyyk":
        return "https://vignette.wikia.nocookie.net/starwars/images/d/d0/Kashyyyk_FFGRebellion.png/revision/latest/scale-to-width-down/350"
    case "Polis Massa":
        return "https://vignette.wikia.nocookie.net/starwars/images/2/22/PolisMassaNEGAS.jpg/revision/latest/scale-to-width-down/350"
    case "Mygeeto":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/e/ee/Mygeeto.jpg/revision/latest/scale-to-width-down/350"
    case "Felucia":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/d/dc/Felucia_tcw.jpg/revision/latest/scale-to-width-down/350"
    case "Cato Neimoidia":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/c/c0/CatoNeimoidia-SS.png/revision/latest/scale-to-width-down/350"
    case "Saleucami":
        return "https://vignette.wikia.nocookie.net/starwars/images/a/a3/Saleucami_MPQ.png/revision/latest/scale-to-width-down/350"
    //case "Stewjon":
        //return ""
    case "Eriadu":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/5/58/Eriadu.jpg"
    case "Corellia":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/7/7f/Corellia_SOF.png/revision/latest/scale-to-width-down/350"
    case "Rodia":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/c/c3/Rodia_canon.png/revision/latest/scale-to-width-down/350"
    case "Nal Hutta":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/0/0d/NalHutta-HFZ.png/revision/latest/scale-to-width-down/350"
    case "Dantooine":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/9/9f/DantooineRebels.png/revision/latest/scale-to-width-down/350"
    case "Bestine IV":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/d/d2/Bestine_eaw.jpg/revision/latest/scale-to-width-down/350"
    case "Ord Mantell":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/3/36/Ord_Mantell_EotECR.png/revision/latest/scale-to-width-down/350"
    case "Trandosha":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/4/40/Trandosha-PL.png/revision/latest/scale-to-width-down/350"
    case "Socorro":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/a/aa/SocorroSystem.jpg/revision/latest/scale-to-width-down/350"
    case "Mon Cala":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/2/24/Mon_Cala_SWCT.png/revision/latest/scale-to-width-down/350"
    case "Chandrila":
        return "https://vignette.wikia.nocookie.net/starwars/images/9/9b/Chandrila_AoRCR.png/revision/latest/scale-to-width-down/350"
    case "Sullust":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/2/2d/SullustAoR.png/revision/latest/scale-to-width-down/350"
    case "Toydaria":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/d/d6/Toydaria-TCW.png/revision/latest/scale-to-width-down/350"
    case "Malastare":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/d/df/MalastareNEGAS.jpg/revision/latest/scale-to-width-down/350"
    case "Dathomir":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/f/f3/Dathomir-Massacre.png/revision/latest/scale-to-width-down/350"
    case "Ryloth":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/b/b7/Ryloth_Rebels.png/revision/latest/scale-to-width-down/350"
    case "Aleen Minor":
        return "https://vignette.wikia.nocookie.net/starwars/images/f/f6/Aleen_NEGAS.jpg/revision/latest/scale-to-width-down/350"
    case "Vulpter":
        return "https://vignette.wikia.nocookie.net/starwars/images/b/be/Vulpter_FF7.jpg/revision/latest/scale-to-width-down/350"
    case "Troiken":
        return "https://vignette.wikia.nocookie.net/starwars/images/3/3a/TroikenQuermia.jpg"
    case "Tund":
        return "https://vignette.wikia.nocookie.net/starwars/images/2/27/Tundatlas.jpg/revision/latest/scale-to-width-down/355"
    case "Haruun Kal":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/9/92/HaruunKalCSWE.JPG"
    case "Cerea":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/c/cc/Cerea-FDCR.png/revision/latest/scale-to-width-down/350"
    case "Glee Anselm":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/b/ba/Glee_Anselm_fuel_log.png"
    case "Iridonia":
        return "https://vignette.wikia.nocookie.net/starwars/images/c/c5/Iridonia.jpg/revision/latest/scale-to-width-down/350"
    case "Tholoth":
        return "https://lh4.googleusercontent.com/nR67QB9DURX0lWxzQ8Iw6N5lMp7_n1la--KCLPHxvYYoMr70dkQOxuOopqP1ZrIn6wDw7KvkqRH36Wk5CS91vm_mz9M86mzBVrWToVgTLNR6g5waQ-JAJfg2QxAMqE31BAfrfO91"
    case "Iktotch":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/f/f1/Iktotch_FDNP.png/revision/latest/scale-to-width-down/350"
    case "Quermia":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/2/29/Quermia_NEGAS.jpg/revision/latest/scale-to-width-down/350"
    case "Dorin":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/9/9b/Dorin-FDCR.png/revision/latest/scale-to-width-down/350"
    case "Champala":
        return "https://vignette.wikia.nocookie.net/starwars/images/d/d7/Champala_NEGAS.jpg/revision/latest/scale-to-width-down/350"
    case "Mirial":
        return "https://vignette.wikia.nocookie.net/camino-estelar/images/e/e0/Mirial.jpg/revision/latest?cb=20160105035654&path-prefix=es"
    case "Serenno":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/b/b2/Serenno-Massacre.png/revision/latest/scale-to-width-down/350"
    case "Concord Dawn":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/7/73/Concord_Dawn_system.jpeg/revision/latest/scale-to-width-down/350"
    case "Zolan":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/6/66/Zolan.jpg/revision/latest/scale-to-width-down/350"
    case "Ojom":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/9/9f/Ojom.jpg/revision/latest/scale-to-width-down/350"
    case "Skako":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/c/cd/Skako.jpg"
    case "Muunilinst":
        return "https://vignette.wikia.nocookie.net/starwars/images/1/19/Muunilinst.jpg/revision/latest/scale-to-width-down/350"
    case "Shili":
        return "https://vignette.wikia.nocookie.net/starwars/images/b/b8/ShiliNEGAS.jpg/revision/latest/scale-to-width-down/350"
    case "Kalee":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/0/08/KaleePlanet.jpg/revision/latest/scale-to-width-down/350"
    case "Umbara":
        return "https://vignette.wikia.nocookie.net/starwars/images/2/2d/Umbara-Planet_SWTOR.jpg/revision/latest/scale-to-width-down/350"
    case "Jakku":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/f/f4/Jakku_-_full_-_SW_Poe_Dameron_Flight_Log_.png/revision/latest/scale-to-width-down/350"
    default:
        return ""
    }
    
}



