//
//  Starship.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 25/8/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import Foundation
import UIKit

class Starship {
    
    let id : Int
    let name : String
    let model : String
    let manufacturer : String
    let cost_in_credits : String
    let length : String
    let max_atmosphering_speed : String
    let crew : String
    let passengers : String
    let cargo_capacity : String
    let consumables : String
    let hyperdrive_rating : String
    let MGLT : String
    let starship_class : String
    var pilots : [String]
    var films : [Int]
    let url : Int
    var image : UIImage
    
    init(id: Int, name: String, model: String, manufacturer: String, cost_in_credits: String, length: String, max_atmosphering_speed: String, crew: String, passengers: String, cargo_capacity: String, consumables: String, hyperdrive_rating: String, MGLT: String, starship_class: String, pilots: [String], films: [Int], url: Int, image: UIImage) {
        self.id = id
        self.name = name
        self.model = model
        self.manufacturer = manufacturer
        self.cost_in_credits = cost_in_credits
        self.length = length
        self.max_atmosphering_speed = max_atmosphering_speed
        self.crew = crew
        self.passengers = passengers
        self.cargo_capacity = cargo_capacity
        self.consumables = consumables
        self.hyperdrive_rating = hyperdrive_rating
        self.MGLT = MGLT
        self.starship_class = starship_class
        self.pilots = pilots
        self.films = films
        self.url = url
        self.image = image
    }
    
} // End - class Starships


// ---------------------------------------------------------------------------------

// MARK: - Get JSON from StarWars API


// Cargar los datos del planeta con los datos de la API

func generateStarshipFromJsonData(dataStarship: AnyObject) -> Starship {
    
    // Extraemos los valores del diccionario
    let id = dataStarship["id"] as! Int
    let name = (dataStarship["name"] as! String).capitalizingFirstLetter()
    let model = (dataStarship["model"] as! String) == "unknown" ? "-" : (dataStarship["model"] as! String).capitalizingFirstLetter()
    let manufacturer = (dataStarship["manufacturer"] as! String) == "unknown" ? "-" : dataStarship["manufacturer"] as! String
    let cost_in_credits = (dataStarship["cost_in_credits"] as! String) == "unknown" ? "-" : dataStarship["cost_in_credits"] as! String
    let length = (dataStarship["length"] as! String) == "unknown" ? "-" : (dataStarship["length"] as! String).capitalizingFirstLetter()
    let max_atmosphering_speed = (dataStarship["max_atmosphering_speed"] as! String) == "unknown" || (dataStarship["max_atmosphering_speed"] as! String) == "n/a" ? "-" : dataStarship["max_atmosphering_speed"] as! String
    let crew = (dataStarship["crew"] as! String) == "unknown" ? "-" : (dataStarship["crew"] as! String).capitalizingFirstLetter()
    let passengers = (dataStarship["passengers"] as! String) == "unknown" ? "-" : dataStarship["passengers"] as! String
    let cargo_capacity = (dataStarship["cargo_capacity"] as! String) == "unknown" ? "-" : dataStarship["cargo_capacity"] as! String
    let consumables = (dataStarship["consumables"] as! String) == "unknown" ? "-" : dataStarship["consumables"] as! String
    let hyperdrive_rating = (dataStarship["hyperdrive_rating"] as! String) == "unknown" ? "-" : dataStarship["hyperdrive_rating"] as! String
    let MGLT = (dataStarship["MGLT"] as! String) == "unknown" ? "-" : dataStarship["MGLT"] as! String
    let starship_class = (dataStarship["starship_class"] as! String) == "unknown" ? "-" : (dataStarship["starship_class"] as! String).capitalizingFirstLetter()
    
    
    // Descarga la imagen desde Internet
    var image = #imageLiteral(resourceName: "starshipIcon") // Imagen por defecto
    let imageUrl = dataStarship["image"] as! String
    if let url = URL(string: imageUrl) {
        do {
            let data = try Data(contentsOf: url)
            if let downloadImage = UIImage(data: data) {
                image = downloadImage
            }
            
        } catch let error {
            print("Error al descargar la imagen de \(name): \(error.localizedDescription)")
        }
    }
    
    
    // Extraemos el array de films de cada personaje y lo convertimos a Int
    let extractedEpisodes = dataStarship["episodes"] as! [String]
    var episodes : [Int] = convertArrayStringToInt(arrayOfString: extractedEpisodes)
    episodes.sort{ $0 < $1}
    
    let extractedPilots = dataStarship["pilots"] as! [String]
    let auxPilots : [Int] = convertArrayStringToInt(arrayOfString: extractedPilots)
    let pilots : [String] = convertArrayIntToString(arrayOfInt: auxPilots)
    
    let auxURL = dataStarship["url"] as! String
    let url = convertStringToInt(string: auxURL)
    
    // Almacenamos los valores obtenidos en una instancia de Planet
    let starship = Starship(id: id, name: name, model: model, manufacturer: manufacturer, cost_in_credits: cost_in_credits, length: length, max_atmosphering_speed: max_atmosphering_speed, crew: crew, passengers: passengers, cargo_capacity: cargo_capacity, consumables: consumables, hyperdrive_rating: hyperdrive_rating, MGLT: MGLT, starship_class: starship_class, pilots: pilots, films: episodes, url: url, image: image)
    
    return starship
} // End - func generateStarshipFromJsonData


func returnArrayOfAllStarshipsFromData(result: [AnyObject]) -> [Starship] {
    
    var arrayOfStarship : [Starship] = []
    
    for object in result {
        
        let starship = generateStarshipFromJsonData(dataStarship: object)
        
        arrayOfStarship.append(starship)
    }
    
    return arrayOfStarship
    
}



/*
func getArrayOfStarships(numberOfStarships : Int, completion: @escaping (Starship?, Int?) -> Void ) {
    
    // La API no devuelve el número total de Starships, hay que meterlo a mano
    var successCount = 77// numberOfStarships
    
    let totalOfStarships = 77 // numberOfStarships
    
    for value in 1...totalOfStarships {
        
        let urlString = "https://swapi.co/api/starships/\(value)/?format=json"
        
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
                let dataStarship = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Comprobación de que el objeto existe o no está vacío
                if let error = dataStarship["detail"] as? String {
                    print("Error: Data \(value) \(error)")
                    // Retiramos al contador un objeto erroneo para que contabilice solo los exitosos
                    successCount -= 1
                    completion(nil, successCount)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let name = (dataStarship["name"] as! String).capitalizingFirstLetter()
                let model = (dataStarship["model"] as! String) == "unknown" ? "-" : (dataStarship["model"] as! String).capitalizingFirstLetter()
                let manufacturer = (dataStarship["manufacturer"] as! String) == "unknown" ? "-" : dataStarship["manufacturer"] as! String
                let cost_in_credits = (dataStarship["cost_in_credits"] as! String) == "unknown" ? "-" : dataStarship["cost_in_credits"] as! String
                let length = (dataStarship["length"] as! String) == "unknown" ? "-" : (dataStarship["length"] as! String).capitalizingFirstLetter()
                let max_atmosphering_speed = (dataStarship["max_atmosphering_speed"] as! String) == "unknown" || (dataStarship["max_atmosphering_speed"] as! String) == "n/a" ? "-" : dataStarship["max_atmosphering_speed"] as! String
                let crew = (dataStarship["crew"] as! String) == "unknown" ? "-" : (dataStarship["crew"] as! String).capitalizingFirstLetter()
                let passengers = (dataStarship["passengers"] as! String) == "unknown" ? "-" : dataStarship["passengers"] as! String
                let cargo_capacity = (dataStarship["cargo_capacity"] as! String) == "unknown" ? "-" : dataStarship["cargo_capacity"] as! String
                let consumables = (dataStarship["consumables"] as! String) == "unknown" ? "-" : dataStarship["consumables"] as! String
                let hyperdrive_rating = (dataStarship["hyperdrive_rating"] as! String) == "unknown" ? "-" : dataStarship["hyperdrive_rating"] as! String
                let MGLT = (dataStarship["MGLT"] as! String) == "unknown" ? "-" : dataStarship["MGLT"] as! String
                let starship_class = (dataStarship["starship_class"] as! String) == "unknown" ? "-" : (dataStarship["starship_class"] as! String).capitalizingFirstLetter()
                
                
                // Descarga la imagen desde Internet
                var image = #imageLiteral(resourceName: "starshipIcon") // Imagen por defecto
                if let url = URL(string: showStarshipFromUrl(starshipName: name)) {
                    
                    do {
                        let data = try Data(contentsOf: url)
                        guard let downloadImage = UIImage(data: data) else { return }
                        image = downloadImage
                        
                    } catch let error {
                        print("Error al descargar la imagen de \(name): \(error.localizedDescription)")
                    }
                }
                
                
                // Extraemos el array de films de cada personaje y lo convertimos a Int
                let extractedFilms = dataStarship["films"] as! [String]
                var films : [Int] = convertArrayStringToInt(arrayOfString: extractedFilms)
                films.sort{ $0 < $1}
                
                let extractedPilots = dataStarship["pilots"] as! [String]
                let auxPilots : [Int] = convertArrayStringToInt(arrayOfString: extractedPilots)
                let pilots : [String] = convertArrayIntToString(arrayOfInt: auxPilots)
                
                let auxURL = dataStarship["url"] as! String
                let url = convertStringToInt(string: auxURL)
                
                // Almacenamos los valores obtenidos en una instancia de Planet
                let starship = Starship(name: name, model: model, manufacturer: manufacturer, cost_in_credits: cost_in_credits, length: length, max_atmosphering_speed: max_atmosphering_speed, crew: crew, passengers: passengers, cargo_capacity: cargo_capacity, consumables: consumables, hyperdrive_rating: hyperdrive_rating, MGLT: MGLT, starship_class: starship_class, pilots: pilots, films: films, url: url, image: image)
                
                completion(starship, successCount)
            } catch {
                successCount -= 1
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
    
} // End - getArrayOfStarships
*/
// ---------------------------------------------------------------------------------

// MARK: - Get JSON from StarWars API


func getArrayOfPlanetsFromID(id: Int, result: [AnyObject]) -> Starship? {
    
    var starship : Starship? = nil
    
    for object in result {
        
        // Comprobación que corresponde a la película
        // Recogemos los episodios en los que aparece el personaje
        let starshipID = object["id"] as! Int
        
        if starshipID == id {
            
            starship = generateStarshipFromJsonData(dataStarship: object)
            
            return starship
            
        } // End - if
        
    } // End - for
    
    return starship
    
} // End - getArrayOfPlanetsFromID

/*
func getStarshipByID(value : Int, numberOfObjects: Int = 0, completion: @escaping (Starship?, Int?) -> Void ) {
    
    var successCount = numberOfObjects
    
    let urlString = "https://swapi.co/api/starship/\(value)/?format=json"
    
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
            let dataStarship = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
            
            // Comprobación de que el objeto existe o no está vacío
            if let error = dataStarship["detail"] as? String {
                print("Error: Data \(value) \(error)")
                // Retiramos al contador un objeto erroneo para que contabilice solo los exitosos
                successCount -= 1
                completion(nil, successCount)
                return
            }
            
            // Obtenemos los valores del diccionario
            let name = (dataStarship["name"] as! String).capitalizingFirstLetter()
            
            let model = (dataStarship["model"] as! String) == "unknown" ? "-" : (dataStarship["model"] as! String).capitalizingFirstLetter()
            let manufacturer = (dataStarship["manufacturer"] as! String) == "unknown" ? "-" : dataStarship["manufacturer"] as! String
            let cost_in_credits = (dataStarship["cost_in_credits"] as! String) == "unknown" ? "-" : dataStarship["cost_in_credits"] as! String
            let length = (dataStarship["length"] as! String) == "unknown" ? "-" : (dataStarship["length"] as! String).capitalizingFirstLetter()
            let max_atmosphering_speed = (dataStarship["max_atmosphering_speed"] as! String) == "unknown" || (dataStarship["max_atmosphering_speed"] as! String) == "N/A" ? "-" : dataStarship["max_atmosphering_speed"] as! String
            let crew = (dataStarship["crew"] as! String) == "unknown" ? "-" : (dataStarship["crew"] as! String).capitalizingFirstLetter()
            let passengers = (dataStarship["passengers"] as! String) == "unknown" ? "-" : dataStarship["passengers"] as! String
            let cargo_capacity = (dataStarship["cargo_capacity"] as! String) == "unknown" ? "-" : dataStarship["cargo_capacity"] as! String
            let consumables = (dataStarship["consumables"] as! String) == "unknown" ? "-" : dataStarship["consumables"] as! String
            let hyperdrive_rating = (dataStarship["hyperdrive_rating"] as! String) == "unknown" ? "-" : dataStarship["hyperdrive_rating"] as! String
            let MGLT = (dataStarship["MGLT"] as! String) == "unknown" ? "-" : dataStarship["MGLT"] as! String
            let starship_class = (dataStarship["starship_class"] as! String) == "unknown" ? "-" : dataStarship["starship_class"] as! String
            
            
            // Descarga la imagen desde Internet
            var image = #imageLiteral(resourceName: "starshipIcon") // Imagen por defecto
            if let url = URL(string: showPlanetFromUrl(planetName: name)) {
                
                do {
                    let data = try Data(contentsOf: url)
                    guard let downloadImage = UIImage(data: data) else { return }
                    image = downloadImage
                    
                } catch let error {
                    print("Error al descargar la imagen de \(name): \(error.localizedDescription)")
                }
            }
            
            
            // Extraemos el array de films de cada personaje y lo convertimos a Int
            let extractedFilms = dataStarship["films"] as! [String]
            var films : [Int] = convertArrayStringToInt(arrayOfString: extractedFilms)
            films.sort{ $0 < $1}
            
            let extractedPilots = dataStarship["pilots"] as! [String]
            let auxPilots : [Int] = convertArrayStringToInt(arrayOfString: extractedPilots)
            let pilots : [String] = convertArrayIntToString(arrayOfInt: auxPilots)
            
            let auxURL = dataStarship["url"] as! String
            let url = convertStringToInt(string: auxURL)
            
            // Almacenamos los valores obtenidos en una instancia de Planet
            let starship = Starship(name: name, model: model, manufacturer: manufacturer, cost_in_credits: cost_in_credits, length: length, max_atmosphering_speed: max_atmosphering_speed, crew: crew, passengers: passengers, cargo_capacity: cargo_capacity, consumables: consumables, hyperdrive_rating: hyperdrive_rating, MGLT: MGLT, starship_class: starship_class, pilots: pilots, films: films, url: url, image: image)
            
            completion(starship, successCount)
        } catch {
            successCount -= 1
            debugPrint(error)
        }
    }
    
    // And finally send it
    task.resume()
    
} // End - getStarshipByID
*/


// ---------------------------------------------------------------------------------

// MARK: - Download Image from URL as per the planet name

func showStarshipFromUrl(starshipName: String) -> String {
    
    switch starshipName {
        
    case "A-wing":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/8/8d/A-wing_DICE.png/revision/latest/scale-to-width-down/350"
    case "AA-9 Coruscant freighter":
        return "https://vignette.wikia.nocookie.net/starwars/images/c/c7/Aa9coruscantfreighter.jpg/revision/latest/scale-to-width-down/350"
    case "Arc-170":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/3/32/Starfigher.jpg/revision/latest/scale-to-width-down/350"
    case "B-wing":
        return "https://vignette.wikia.nocookie.net/starwars/images/7/71/BWingsKillISD2-ST.jpg/revision/latest/scale-to-width-down/350"
    case "Banking clan frigate":
        return "https://vignette.wikia.nocookie.net/starwars/images/0/07/Munificent_TCW.jpg/revision/latest/scale-to-width-down/350"
    case "Belbullab-22 starfighter":
        return "https://vignette.wikia.nocookie.net/starwars/images/3/3e/Soulless_One2_TCW.jpg/revision/latest/scale-to-width-down/350"
    case "CR90 corvette":
        return "https://vignette.wikia.nocookie.net/starwars/images/4/47/Rebels-TantiveIVConceptArt-CroppedBackground.png/revision/latest/scale-to-width-down/350"
    case "Calamari Cruiser":
        return "https://vignette.wikia.nocookie.net/jvs/images/8/84/MC75_Star_Cruiser.jpg/revision/latest/scale-to-width-down/350"
    case "Death Star":
        return "https://vignette.wikia.nocookie.net/starwars/images/9/9d/DSI_hdapproach.png/revision/latest/scale-to-width-down/350"
    case "Droid control ship":
        return "https://vignette.wikia.nocookie.net/starwars/images/9/95/Lucrehulk_battleship_TCW.jpg/revision/latest/scale-to-width-down/350"
    case "EF76 Nebulon-B escort frigate":
        return "https://vignette.wikia.nocookie.net/starwars/images/5/50/NBfrigate.JPG/revision/latest/scale-to-width-down/350"
    case "Executor":
        return "https://lumiere-a.akamaihd.net/v1/images/databank_executor_01_169_8157df82.jpeg?width=400"
    case "H-type Nubian yacht":
        return "https://vignette.wikia.nocookie.net/starwars/images/f/fb/Nabooyacht.jpg"
    case "Imperial shuttle":
        return "https://vignette.wikia.nocookie.net/starwars/images/c/c2/Tydirium-ROTJ.png/revision/latest/scale-to-width-down/350"
    case "J-type diplomatic barge":
        return "https://vignette.wikia.nocookie.net/starwars/images/2/2b/Royalcruiser.jpg/revision/latest/scale-to-width-down/350"
    case "Jedi Interceptor":
        return "https://vignette.wikia.nocookie.net/starwars/images/7/7a/Jsf_duo2.jpg/revision/latest/scale-to-width-down/350"
    case "Jedi starfighter":
        return "https://vignette.wikia.nocookie.net/starwars/images/7/79/Jedi_Starfighter_EpII.png/revision/latest/scale-to-width-down/350"
    case "Millennium Falcon":
        return "https://vignette.wikia.nocookie.net/starwars/images/4/43/MillenniumFalconTFA-Fathead.png/revision/latest/scale-to-width-down/400"
    case "Naboo Royal Starship":
        return "https://vignette.wikia.nocookie.net/starwars/images/9/9a/Naboo_Royal_Starship_SWE.png/revision/latest/scale-to-width-down/350"
    case "Naboo fighter":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/d/d2/Naboo_N-1_fighter_1.jpg/revision/latest/scale-to-width-down/350"
    case "Naboo star skiff":
        return "https://vignette.wikia.nocookie.net/starwars/images/4/44/Naboo_Star_Skiff.jpg/revision/latest?cb=20071011134950&path-prefix=nl"
    case "Rebel transport":
        return "https://vignette.wikia.nocookie.net/starwars/images/e/eb/GR-75_Medium_Transport.jpg/revision/latest/scale-to-width-down/350"
    case "Republic Assault ship":
        return "https://vignette.wikia.nocookie.net/starwars/images/4/4b/Acclamator.jpg"
    case "Republic attack cruiser":
        return "https://vignette.wikia.nocookie.net/starwars/images/0/00/ResoluteVSD.png/revision/latest/scale-to-width-down/350"
    case "Republic Cruiser":
        return "https://vignette.wikia.nocookie.net/es.starwars/images/d/d1/Republic_Cruiser_SWE.png/revision/latest/scale-to-width-down/350"
    case "Scimitar":
        return "https://vignette.wikia.nocookie.net/swfanon/images/a/a8/Scimitar.jpg/revision/latest/scale-to-width-down/350"
    case "Sentinel-class landing craft":
        return "https://vignette.wikia.nocookie.net/starwars/images/5/5b/Imperial_Sentinel-class_shuttle.png/revision/latest/scale-to-width-down/350"
    case "Slave 1":
        return "https://vignette.wikia.nocookie.net/starwars/images/b/ba/Slave_I_DICE.png/revision/latest/scale-to-width-down/350"
    case "Solar Sailer":
        return "https://vignette.wikia.nocookie.net/starwars/images/6/60/Solar_Sailer_Coruscant.jpg/revision/latest/scale-to-width-down/350"
    case "Star Destroyer":
        return "https://vignette.wikia.nocookie.net/starwars/images/5/58/ISD-I.png/revision/latest/scale-to-width-down/350"
    case "T-70 X-wing fighter":
        return "https://vignette.wikia.nocookie.net/starwars/images/f/f5/T70XWing-Fathead.png/revision/latest/scale-to-width-down/350"
    case "TIE Advanced x1":
        return "https://vignette.wikia.nocookie.net/starwars/images/1/1d/Vader_TIEAdvanced_SWB.png/revision/latest/scale-to-width-down/350"
    case "Theta-class T-2c shuttle":
        return "https://vignette.wikia.nocookie.net/starwars/images/8/8e/Theta-class_shuttle.png/revision/latest/scale-to-width-down/350"
    case "Trade Federation cruiser":
        return "https://vignette.wikia.nocookie.net/battlefront/images/1/17/Providence-Class.png/revision/latest/scale-to-width-down/300?cb=20110910180110"
    case "V-wing":
        return "https://vignette.wikia.nocookie.net/vsbattles/images/2/2c/V-wing_02.jpg/revision/latest/scale-to-width-down/350"
    case "X-wing":
        return "https://vignette.wikia.nocookie.net/starwars/images/2/22/RedFive_X-wing_SWB.png/revision/latest/scale-to-width-down/350"
    case "Y-wing":
        return "https://vignette.wikia.nocookie.net/starwars/images/8/81/Y-wing.png/revision/latest/scale-to-width-down/350"
        
    default:
        return ""
    }
    
}


