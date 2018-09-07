//
//  Person.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 20/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import Foundation
import UIKit

class Person {
    
    let name : String
    let birth_year : String
    let gender : String
    let height : String
    let mass : String
    let hair_color : String
    let skin_color : String
    let eye_color : String
    let homeworld : String
    let vehicles : [Int]
    let starships : [Int]
    let species : [Int]
    /*let url : String*/
    var image : UIImage
    var films : [Int]
    
    init(name: String, birth_year: String, gender: String, films: [Int], image: UIImage, height : String, mass : String, hair_color : String, skin_color : String, eye_color : String, homeworld: String, vehicles: [Int], starships: [Int], species: [Int]) {
        self.name = name
        self.birth_year = birth_year
        self.gender = gender
        self.image = image
        self.films = films
        self.height = height
        self.mass = mass
        self.hair_color = hair_color
        self.skin_color = skin_color
        self.eye_color = eye_color
        self.homeworld = homeworld
        self.vehicles = vehicles
        self.starships = starships
        self.species = species
    }
} // End - class Person

// ---------------------------------------------------------------------------------
// MARK: - Get JSON from StarWars API


func getArrayOfCharacters(numberOfCharacters : Int, completion: @escaping (Person?, Int?) -> Void ) {
    
    // La API no devuelve el número total de Characters, hay que meterlo a mano
    var successCount = 88// numberOfCharacters
    let totalOfCharacters = 88 // numberOfCharacters
    
    for value in 1...totalOfCharacters {
        
        let urlString = "https://swapi.co/api/people/\(value)/?format=json"
        
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
                let dataPerson = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Comprobación de que el objeto existe o no está vacío
                if let error = dataPerson["detail"] as? String {
                    print("Error: Data \(value) \(error)")
                    // Retiramos al contador un objeto erroneo para que contabilice solo los exitosos
                    successCount -= 1
                    completion(nil, successCount)
                    return
                }
                
                // Generamos la persona con los datos del diccionario
                let person = generatePersonFromJsonData(dataPerson: dataPerson)
                
                completion(person, successCount)
                
            } catch {
                successCount -= 1
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
    
} // End - getArrayOfCharacters(numberOfCharacters : Int

// ---------------------------------------------------------------------------------

// Cargar los datos del personaje con los datos de la API

func generatePersonFromJsonData(dataPerson: [String:Any]) -> Person {
    
    // Extraemos los valores del diccionario
    let name = dataPerson["name"] as! String
    let gender = (dataPerson["gender"] as! String) == "none" || (dataPerson["gender"] as! String) == "n/a" ? "-" : (dataPerson["gender"] as! String).capitalizingFirstLetter()
    let birth_year = (dataPerson["birth_year"] as! String) == "unknown" ? "-" : dataPerson["birth_year"] as! String
    let height = (dataPerson["height"] as! String) == "unknown" ? "-" : dataPerson["height"] as! String
    let mass = (dataPerson["mass"] as! String) == "unknown" ? "-" : dataPerson["mass"] as! String
    let hair_color = (dataPerson["hair_color"] as! String) == "n/a" || (dataPerson["hair_color"] as! String) == "none" || (dataPerson["hair_color"] as! String) == "unknown" ? "-" : (dataPerson["hair_color"] as! String).capitalizingFirstLetter()
    let skin_color = (dataPerson["skin_color"] as! String) == "none" || (dataPerson["skin_color"] as! String) == "unknown" ? "-" : (dataPerson["skin_color"] as! String).capitalizingFirstLetter()
    let eye_color = dataPerson["eye_color"] as! String == "unknown" || (dataPerson["eye_color"] as! String) == "none" ? "-" : (dataPerson["eye_color"] as! String).capitalizingFirstLetter()
    let homeworld = dataPerson["homeworld"] as! String == "unknown" || (dataPerson["homeworld"] as! String) == "none" ? "-" : (dataPerson["homeworld"] as! String).capitalizingFirstLetter()
    
    // Descarga la imagen desde Internet
    var image = #imageLiteral(resourceName: "contactIcon") // Imagen por defecto
    if let url = URL(string: showCharacterFromUrl(characterName: name)) {
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
    let extractedFilms = dataPerson["films"] as! [String]
    var films : [Int] = convertArrayStringToInt(arrayOfString: extractedFilms)
    films.sort{ $0 < $1 }
    
    // Extraemos el array de vehicles de cada personaje y lo convertimos a Int
    let extractedVehicles = dataPerson["vehicles"] as! [String]
    var vehicles : [Int] = convertArrayStringToInt(arrayOfString: extractedVehicles)
    vehicles.sort{ $0 < $1 }
    
    // Extraemos el array de vehicles de cada personaje y lo convertimos a Int
    let extractedStarships = dataPerson["starships"] as! [String]
    var starships : [Int] = convertArrayStringToInt(arrayOfString: extractedStarships)
    starships.sort{ $0 < $1 }
    
    // Extraemos el array de vehicles de cada personaje y lo convertimos a Int
    let extractedSpecies = dataPerson["species"] as! [String]
    var species : [Int] = convertArrayStringToInt(arrayOfString: extractedSpecies)
    species.sort{ $0 < $1 }
    
    // Almacenamos los valores obtenidos en una instancia de Planet
    let person = Person(name: name, birth_year: birth_year, gender: gender, films: films, image: image, height: height, mass: mass, hair_color: hair_color, skin_color: skin_color, eye_color: eye_color, homeworld:  homeworld, vehicles: vehicles, starships: starships, species: species)
    
    return person
} // End - func generatePersonFromJsonData

// ---------------------------------------------------------------------------------

func getArrayOfCharactersFromFilm(film : Film, completion: @escaping (Person?, Int?) -> Void ) {
    
    var successCount = film.characters.count
    
    for value in film.characters {
        
        let urlString = "https://swapi.co/api/people/\(value)/?format=json"
        
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
                let dataPerson = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Comprobación de que el objeto existe o no está vacío
                if let error = dataPerson["detail"] as? String {
                    print("Error: Data \(value) \(error)")
                    // Retiramos al contador un objeto erroneo para que contabilice solo los exitosos
                    successCount -= 1
                    completion(nil, successCount)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let person = generatePersonFromJsonData(dataPerson: dataPerson)
 
                completion(person, successCount)
                
            } catch {
                successCount -= 1
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
    
} // End - getArrayOfCharactersFromFilm(film : Film


// ---------------------------------------------------------------------------------

func getArrayOfCharactersFromPlanet(planet : Planet, completion: @escaping (Person?, Int?) -> Void ) {
    
    var successCount = planet.residents.count
    
    for value in planet.residents {
        
        let urlString = "https://swapi.co/api/people/\(value)/?format=json"
        
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
                let dataPerson = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Comprobación de que el objeto existe o no está vacío
                if let error = dataPerson["detail"] as? String {
                    print("Error: Data \(value) \(error)")
                    // Retiramos al contador un objeto erroneo para que contabilice solo los exitosos
                    successCount -= 1
                    completion(nil, successCount)
                    return
                }

                // Obtenemos los valores del diccionario
                let person = generatePersonFromJsonData(dataPerson: dataPerson)
                
                completion(person, successCount)
                
            } catch {
                successCount -= 1
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
    
} // End - getArrayOfCharactersFromPlanet


// ---------------------------------------------------------------------------------

func getArrayOfCharactersFromStarship(starship : Starship, completion: @escaping (Person?, Int?) -> Void ) {
    
    var successCount = starship.pilots.count
    
    for value in starship.pilots {
        
        let urlString = "https://swapi.co/api/people/\(value)/?format=json"
        
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
                let dataPerson = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Comprobación de que el objeto existe o no está vacío
                if let error = dataPerson["detail"] as? String {
                    print("Error: Data \(value) \(error)")
                    // Retiramos al contador un objeto erroneo para que contabilice solo los exitosos
                    successCount -= 1
                    completion(nil, successCount)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let person = generatePersonFromJsonData(dataPerson: dataPerson)
                
                completion(person, successCount)
                
            } catch {
                successCount -= 1
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
    
} // End - getArrayOfCharactersFromPlanet

// ---------------------------------------------------------------------------------

func getArrayOfCharactersByID(value : Int, numberOfObjects: Int = 0, completion: @escaping (Person?, Int?) -> Void ) {
    
    var successCount = numberOfObjects
        
        let urlString = "https://swapi.co/api/people/\(value)/?format=json"
        
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
                let dataPerson = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Comprobación de que el objeto existe o no está vacío
                if let error = dataPerson["detail"] as? String {
                    print("Error: Data \(value) \(error)")
                    // Retiramos al contador un objeto erroneo para que contabilice solo los exitosos
                    successCount -= 1
                    completion(nil, successCount)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let person = generatePersonFromJsonData(dataPerson: dataPerson)
                
                completion(person, successCount)
                
            } catch {
                successCount -= 1
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    
} // End - getArrayOfCharactersByID

// ---------------------------------------------------------------------------------

// MARK: - Download Image from URL as per the planet name

func showCharacterFromUrl(characterName: String) -> String {
    switch characterName {
        case "Luke Skywalker":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/d/d9/Luke-rotjpromo.jpg"
        case "C-3PO":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/0/03/C-3PO_TLJ_Card_Trader.png/revision/latest/scale-to-width-down/300"
        case "R2-D2":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/e/eb/ArtooTFA2-Fathead.png/revision/latest/scale-to-width-down/337"
        case "Darth Vader":
            return "https://vignette.wikia.nocookie.net/villains/images/7/76/Darth_Vader.jpg/revision/latest/scale-to-width-down/350"
        case "Leia Organa":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/f/f3/Leia.jpg"
        case "Owen Lars":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/e/eb/OwenCardTrader.png/revision/latest/scale-to-width-down/350"
        case "Beru Whitesun lars":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/c/cc/BeruCardTrader.png/revision/latest/scale-to-width-down/350"
        case "R5-D4":
            return "https://vignette.wikia.nocookie.net/starwars/images/c/cb/R5-D4_Sideshow.png/revision/latest/scale-to-width-down/350"
        case "Biggs Darklighter":
            return "https://vignette.wikia.nocookie.net/starwars/images/0/00/BiggsHS-ANH.png/revision/latest/scale-to-width-down/350"
        case "Obi-Wan Kenobi":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/4/4e/ObiWanHS-SWE.jpg/revision/latest/scale-to-width-down/350"
        case "Anakin Skywalker":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/6/6f/Anakin_Skywalker_RotS.png/revision/latest/scale-to-width-down/350"
        case "Wilhuff Tarkin":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/c/c1/Tarkininfobox.jpg/revision/latest/scale-to-width-down/350"
        case "Chewbacca":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/4/4f/Chewbacca-TFA.png/revision/latest/scale-to-width-down/350"
        case "Han Solo":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/f/fe/Han_Solo%27s_blaster.jpg/revision/latest/scale-to-width-down/350"
        case "Greedo":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/c/c6/Greedo.jpg"
        case "Jabba Desilijic Tiure":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/b/be/Jabba.jpg"
        case "Wedge Antilles":
            return "https://vignette.wikia.nocookie.net/starwars/images/6/60/WedgeHelmetless-ROTJHD.jpg/revision/latest/scale-to-width-down/350"
        case "Jek Tono Porkins":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/5/53/Porkins.jpg/revision/latest/scale-to-width-down/350"
        case "Yoda":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/d/d6/Yoda_SWSB.png/revision/latest/scale-to-width-down/350"
        case "Palpatine":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/d/d8/Emperor_Sidious.png/revision/latest/scale-to-width-down/350"
        case "Boba Fett":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/5/58/BobaFettMain2.jpg/revision/latest/scale-to-width-down/346"
        case "IG-88":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/8/82/IG-88.jpg/revision/latest/scale-to-width-down/264"
        case "Bossk":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/1/1d/Bossk.png/revision/latest/scale-to-width-down/350"
        case "Lando Calrissian":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/8/8f/Lando_ROTJ.png/revision/latest/scale-to-width-down/350"
        case "Lobot":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/9/96/SWE_Lobot.jpg/revision/latest/scale-to-width-down/350"
        case "Ackbar":
            return "https://vignette.wikia.nocookie.net/starwars/images/2/29/Admiral_Ackbar_RH.png/revision/latest/scale-to-width-down/350"
        case "Mon Mothma":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/4/46/Monmothma.jpg/revision/latest/scale-to-width-down/350"
        case "Arvel Crynyd":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/d/de/Arvel-crynyd.jpg/revision/latest/scale-to-width-down/350"
        case "Wicket Systri Warrick":
            return "https://vignette.wikia.nocookie.net/starwars/images/4/4f/Wicket_RotJ.png/revision/latest/scale-to-width-down/350"
        case "Nien Nunb":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/1/14/Old_nien_nunb_-_profile.png/revision/latest/scale-to-width-down/350"
        case "Qui-Gon Jinn":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/6/66/Qui-Gon_Jinn_SWFB.png/revision/latest/scale-to-width-down/350"
        case "Nute Gunray":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/f/fd/Nute_Gunray_SWE.png/revision/latest/scale-to-width-down/350"
        case "Finis Valorum":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/5/51/ValorumPortrait-SWE.png/revision/latest/scale-to-width-down/350"
        case "Padmé Amidala":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/b/b4/Padme_episodeIII_green.png/revision/latest/scale-to-width-down/344"
        case "Jar Jar Binks":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/7/7f/Jar_Jar_de_Dputado.jpg/revision/latest/scale-to-width-down/350"
        case "Roos Tarpals":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/c/ca/TarpalsHS.jpg/revision/latest/scale-to-width-down/350"
        case "Rugor Nass":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/d/d8/Bossnass.jpg/revision/latest/scale-to-width-down/350"
        case "Ric Olié":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/8/8a/RicOlie.jpg/revision/latest/scale-to-width-down/350"
        case "Watto":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/e/eb/WattoHS.jpg/revision/latest/scale-to-width-down/350"
        case "Sebulba":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/b/ba/Sebulba.jpg"
        case "Quarsh Panaka":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/7/72/PanakaHS-TPM.png/revision/latest/scale-to-width-down/350"
        case "Shmi Skywalker":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/9/98/ShmiSkywalkerDatabank_%28Repurposed%29.jpg/revision/latest/scale-to-width-down/350"
        case "Darth Maul":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/5/50/Darth_Maul_profile.png/revision/latest/scale-to-width-down/350"
        case "Bib Fortuna":
            return "https://vignette.wikia.nocookie.net/starwars/images/3/33/BibFortunaHS-ROTJ.png/revision/latest/scale-to-width-down/350"
        case "Ayla Secura":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/4/4d/Aayla_Secura_SWE.png/revision/latest/scale-to-width-down/350"
        case "Ratts Tyerell":
            return "https://vignette.wikia.nocookie.net/starwars/images/6/68/RattsHS.jpg/revision/latest/scale-to-width-down/350"
        case "Dud Bolt":
            return "https://vignette.wikia.nocookie.net/fr.starwars/images/b/b0/Dud_Bolt.jpg"
        case "Gasgano":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/5/50/Gasganp.jpg/revision/latest/scale-to-width-down/241"
        case "Ben Quadinaros":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/7/7f/Cropped_Quadinaros.png"
        case "Mace Windu":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/f/fc/Mace_Windu.jpg/revision/latest/scale-to-width-down/350"
        case "Ki-Adi-Mundi":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/9/9e/KiAdiMundi.jpg/revision/latest/scale-to-width-down/323"
        case "Kit Fisto":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/1/17/KitFisto-SithSnapshot.jpg/revision/latest/scale-to-width-down/350"
        case "Eeth Koth":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/b/b6/Eeth_Koth_profile.png"
        case "Adi Gallia":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/c/c8/AdiGallia2-SWE.jpg/revision/latest/scale-to-width-down/350"
        case "Saesee Tiin":
            return "https://vignette.wikia.nocookie.net/starwars/images/6/68/Saesee_Tiin_Card_Trader.jpg"
        case "Yarael Poof":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/f/f4/Yarael_Poof_Canon.jpg/revision/latest/scale-to-width-down/344"
        case "Plo Koon":
            return "https://vignette.wikia.nocookie.net/starwars/images/b/bf/PloKoonCardTrader.png/revision/latest/scale-to-width-down/350"
        case "Mas Amedda":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/3/3f/Mas12432.jpg/revision/latest/scale-to-width-down/350"
        case "Gregar Typho":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/5/52/Gregar_Typho.jpg"
        
        case "Cordé":
            return "https://vignette.wikia.nocookie.net/starwars/images/b/b6/Cord%C3%A9_-_SW_Card_Trader.png/revision/latest/scale-to-width-down/350"
        case "Cliegg Lars":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/3/36/ClieggLarsHS-SWE.jpg/revision/latest/scale-to-width-down/350"
        case "Poggle the Lesser":
            return "https://vignette.wikia.nocookie.net/starwars/images/9/93/Poggle_the_lesser_-_sw_card_trader.png/revision/latest/scale-to-width-down/350"
        case "Luminara Unduli":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/4/41/Luminaraprofile.jpg/revision/latest/scale-to-width-down/350"
        case "Barriss Offee":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/3/37/Barrisprofile2.jpg/revision/latest/scale-to-width-down/350"
        case "Dormé":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/8/8b/Dorme.jpg/revision/latest/scale-to-width-down/250"
        case "Dooku":
            return "https://vignette.wikia.nocookie.net/starwars/images/b/b8/Dooku_Headshot.jpg/revision/latest/scale-to-width-down/350"
        case "Bail Prestor Organa":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/5/50/Bail_Organa_Mug.jpg/revision/latest/scale-to-width-down/350"
        case "Jango Fett":
            return "https://vignette.wikia.nocookie.net/starwars/images/7/70/Jango_OP.jpg/revision/latest/scale-to-width-down/350"
        case "Zam Wesell":
            return "https://vignette.wikia.nocookie.net/starwars/images/d/d1/ZamWesell.jpg/revision/latest/scale-to-width-down/350"
        case "Dexter Jettster":
            return "https://vignette.wikia.nocookie.net/fr.starwars/images/4/4c/Dexter_Jettster.jpg/revision/latest/scale-to-width-down/350"
        case "Lama Su":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/7/73/Lama_Su.jpg/revision/latest/scale-to-width-down/318"
        case "Taun We":
            return "https://vignette.wikia.nocookie.net/starwars/images/9/9c/TaunWe.jpg/revision/latest/scale-to-width-down/350"
        case "Jocasta Nu":
            return "https://vignette.wikia.nocookie.net/starwars/images/4/44/Jocasta_Nu.jpg/revision/latest/scale-to-width-down/350"
        case "R4-P17":
            return "https://vignette.wikia.nocookie.net/filmy-podle-lego-her/images/6/6b/R4-P17.jpg"
        case "Wat Tambor":
            return "https://vignette.wikia.nocookie.net/starwars/images/e/e8/TamborBoomHeadshot.jpg/revision/latest/scale-to-width-down/350"
        case "San Hill":
            return "https://vignette.wikia.nocookie.net/swfanon/images/8/8a/3429_plageuis.jpg"
        case "Shaak Ti":
            return "https://vignette.wikia.nocookie.net/starwars/images/4/44/Shaak_Ti_Big_Headshot.jpg/revision/latest/scale-to-width-down/350"
        case "Grievous":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/d/de/Grievoushead.jpg/revision/latest/scale-to-width-down/350"
        case "Tarfful":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/3/37/Tarfful_RotS.png/revision/latest/scale-to-width-down/350"
        case "Raymus Antilles":
            return "https://vignette.wikia.nocookie.net/starwars/images/6/61/RaymusAntilles.jpg"
        case "Sly Moore":
            return "https://vignette.wikia.nocookie.net/starwars/images/e/ec/SlyMooreIsWatchingYouPoop-OfficialPix.jpg/revision/latest/scale-to-width-down/350"
        case "Tion Medon":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/1/1f/Tion.jpg/revision/latest/scale-to-width-down/350"
        case "Finn":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/2/2e/Finn_EW.png/revision/latest/scale-to-width-down/350"
        case "Rey":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/f/f8/ReyTLJEntertainmentWeeklyNovember.png/revision/latest/scale-to-width-down/350"
        case "Poe Dameron":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/7/79/Poe_Dameron_TLJ.png/revision/latest/scale-to-width-down/350"
        case "BB8":
            return "https://vignette.wikia.nocookie.net/starwars/images/6/68/BB8-Fathead.png/revision/latest/scale-to-width-down/350"
        case "Captain Phasma":
            return "https://vignette.wikia.nocookie.net/es.starwars/images/0/02/Phasma.png/revision/latest/scale-to-width-down/350"
        
        default:
            return ""
    }
}
