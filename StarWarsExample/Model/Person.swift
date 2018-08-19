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
    /*let homeworld : String
    let species : [String]
    let vehicles : [String]
    let starships : [String]
    let url : String*/
    let image : UIImage
    var films : [Int]
    
    init(name: String, birth_year: String, gender: String, films: [Int], image: UIImage, height : String, mass : String, hair_color : String, skin_color : String, eye_color : String) {
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
    }
} // End - class Person

// MARK: - Get JSON from StarWars API

// ---------------------------------------------------------------------------------

func getNumberOfObjects(nameResource: String, arrayPeople : [Person], completion: @escaping (Int?) -> Void ) {
    
    let urlString = "https://swapi.co/api/\(nameResource)/?format=json"
    
    // Check that the URL we’ve provided is valid
    guard let urlRequest = URL(string: urlString) else {
        print("Error: cannot create URL")
        completion(nil)
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
            completion(nil)
            return
        }
        
        guard let datos = data else {return}
        
        DispatchQueue.main.async {
            do {
                let dataResource = try JSONDecoder().decode(Resource.self, from: datos)
                //print(dataResource.count)
                completion(dataResource.count)
            } catch {
                debugPrint(error)
            }
        }
        
    }
    
    // And finally send it
    task.resume()
    
} // End - getNumberOfObjects

// ---------------------------------------------------------------------------------

func getArrayOfCharacters(numberOfCharacters : Int, completion: @escaping (Person?, Int?) -> Void ) {
    
    var successCount = numberOfCharacters
    
    for value in 1...numberOfCharacters {
        
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
                    completion(nil, nil)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let name = dataPerson["name"] as! String
                let gender = (dataPerson["gender"] as! String) == "none" || (dataPerson["gender"] as! String) == "n/a" ? "-" : dataPerson["gender"] as! String
                let birth_year = (dataPerson["birth_year"] as! String) == "unknown" ? "-" : dataPerson["birth_year"] as! String
                let image = #imageLiteral(resourceName: "contactIcon")
                let height = (dataPerson["height"] as! String) == "unknown" ? "-" : dataPerson["height"] as! String
                let mass = (dataPerson["mass"] as! String) == "unknown" ? "-" : dataPerson["mass"] as! String
                let hair_color = (dataPerson["hair_color"] as! String) == "n/a" || (dataPerson["hair_color"] as! String) == "none" || (dataPerson["hair_color"] as! String) == "unknown" ? "-" : dataPerson["hair_color"] as! String
                let skin_color = (dataPerson["skin_color"] as! String) == "none" || (dataPerson["skin_color"] as! String) == "unknown" ? "-" : dataPerson["skin_color"] as! String
                let eye_color = dataPerson["eye_color"] as! String == "unknown" || (dataPerson["eye_color"] as! String) == "none" ? "-" : dataPerson["eye_color"] as! String
                
                // Extraemos el array de films de cada personaje y lo convertimos a Int
                let extractedFilms = dataPerson["films"] as! [String]
                let films : [Int] = convertArrayStringToInt(arrayOfString: extractedFilms)
                
                // Almacenamos los valores obtenidos en una instancia de Film
                let person = Person(name: name, birth_year: birth_year, gender: gender, films: films, image: image, height: height, mass: mass, hair_color: hair_color, skin_color: skin_color, eye_color: eye_color)
                
                completion(person, successCount)
            } catch {
                successCount -= 1
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
    
} // End - getArrayOfCharactersFromFilm(numberOfCharacters : Int


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
                    completion(nil, nil)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let name = dataPerson["name"] as! String
                let gender = (dataPerson["gender"] as! String) == "none" || (dataPerson["gender"] as! String) == "n/a" ? "-" : dataPerson["gender"] as! String
                let birth_year = (dataPerson["birth_year"] as! String) == "unknown" ? "-" : dataPerson["birth_year"] as! String
                let image = #imageLiteral(resourceName: "contactIcon")
                let height = (dataPerson["height"] as! String) == "unknown" ? "-" : dataPerson["height"] as! String
                let mass = (dataPerson["mass"] as! String) == "unknown" ? "-" : dataPerson["mass"] as! String
                let hair_color = (dataPerson["hair_color"] as! String) == "n/a" || (dataPerson["hair_color"] as! String) == "none" || (dataPerson["hair_color"] as! String) == "unknown" ? "-" : dataPerson["hair_color"] as! String
                let skin_color = (dataPerson["skin_color"] as! String) == "none" || (dataPerson["skin_color"] as! String) == "unknown" ? "-" : dataPerson["skin_color"] as! String
                let eye_color = dataPerson["eye_color"] as! String == "unknown" || (dataPerson["eye_color"] as! String) == "none" ? "-" : dataPerson["eye_color"] as! String
                
                // Extraemos el array de films de cada personaje y lo convertimos a Int
                let extractedFilms = dataPerson["films"] as! [String]
                let films : [Int] = convertArrayStringToInt(arrayOfString: extractedFilms)
                
                // Almacenamos los valores obtenidos en una instancia de Film
                let person = Person(name: name, birth_year: birth_year, gender: gender, films: films, image: image, height: height, mass: mass, hair_color: hair_color, skin_color: skin_color, eye_color: eye_color)
                
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

