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
}

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
    
}

// ---------------------------------------------------------------------------------

func getArrayOfCharacters(numberOfCharacters : Int, completion: @escaping (Person?) -> Void ) {
    
    for value in 1...numberOfCharacters {
        
        let urlString = "https://swapi.co/api/people/\(value)/?format=json"
        
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
            
            do {
                let dataPerson = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Si hay alguna posición de la API sin contenido, sino dará error
                if let error = dataPerson["detail"] as? String {
                    print("Error: Data \(value) \(error)")
                    completion(nil)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let name = dataPerson["name"] as! String
                let gender = (dataPerson["gender"] as! String) == "none" || (dataPerson["gender"] as! String) == "n/a" ? "-" : dataPerson["gender"] as! String
                let birth_year = (dataPerson["birth_year"] as! String) == "unknown" ? "-" : dataPerson["birth_year"] as! String
                let image = #imageLiteral(resourceName: "contactIcon")
                let height = (dataPerson["height"] as! String) == "unknown" ? "-" : dataPerson["height"] as! String
                let mass = (dataPerson["mass"] as! String) == "unknown" ? "-" : dataPerson["mass"] as! String
                let hair_color = (dataPerson["hair_color"] as! String) == "n/a" || (dataPerson["hair_color"] as! String) == "none" ? "-" : dataPerson["hair_color"] as! String
                let skin_color = (dataPerson["skin_color"] as! String) == "none" ? "-" : dataPerson["skin_color"] as! String
                let eye_color = dataPerson["eye_color"] as! String
                
                // Extraemos el array de films de cada personaje y lo convertimos a Int
                let extractedFilms = dataPerson["films"] as! [String]
                let films : [Int] = convertArrayStringToInt(arrayOfString: extractedFilms)
                
                // Almacenamos los valores obtenidos en una instancia de Film
                let person = Person(name: name, birth_year: birth_year, gender: gender, films: films, image: image, height: height, mass: mass, hair_color: hair_color, skin_color: skin_color, eye_color: eye_color)
                
                completion(person)
            } catch {
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
}

// ---------------------------------------------------------------------------------

func convertArrayStringToInt(arrayOfString: [String]) -> [Int] {
    
    var arrayOfNumber : [Int] = []
    
    for value in arrayOfString {
        if let number = Int(value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            arrayOfNumber += [number]
        }
    }
    
    return arrayOfNumber
}

