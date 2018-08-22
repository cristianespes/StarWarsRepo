//
//  Film.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 20/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import Foundation
import UIKit


class Film {
    
    let title : String
    let opening_crawl: String
    let release_date: String
    let episode: Int
    var image : UIImage
    let url : Int
    let characters: [Int]
    
    init(title: String, description: String, year: String, episode: Int, image: UIImage, url : Int, characters: [Int]) {
        self.title = title
        self.opening_crawl = description
        self.release_date = year
        self.episode = episode
        self.image = image
        self.url = url
        self.characters = characters
    }
    
} // End - class Film

// ---------------------------------------------------------------------------------

// MARK: - Get JSON from StarWars API

func getArrayOfFilms(numberOfFilms : Int, completion: @escaping (Film?, Int?) -> Void ) {
    
    var successCount = numberOfFilms
    
    for value in 1...numberOfFilms {
        
        let urlString = "https://swapi.co/api/films/\(value)/?format=json"
        
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
                let dataFilm = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Comprobación de que el objeto existe o no está vacío
                if let error = dataFilm["detail"] as? String {
                    print("Error: Data \(value) \(error)")
                    // Retiramos al contador un objeto erroneo para que contabilice solo los exitosos
                    successCount -= 1
                    completion(nil, nil)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let title = dataFilm["title"] as! String
                let description = dataFilm["opening_crawl"] as! String
                let episode = dataFilm["episode_id"] as! Int
                let image = UIImage(named: "film\(episode)")
                let auxURL = dataFilm["url"] as! String
                let url = convertStringToInt(string: auxURL)
                
                // Recogemos los personajes de la película
                let auxCharacters = dataFilm["characters"] as! [String]
                var characters : [Int] = []
                for value in auxCharacters {
                    characters += [convertStringToInt(string: value)]
                }
                
                
                var year = dataFilm["release_date"] as! String
                // Convertimos la fecha: yyyy-MM-dd => dd-MM-yyyy
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: year)
                dateFormatter.dateFormat = "MM-dd-yyyy"
                year = dateFormatter.string(from: date!)
                
                year = "Premiere: " + year
                
                
                // Almacenamos los valores obtenidos en una instancia de Film
                let film = Film(title: title, description: description, year: year, episode: episode, image: image!, url: url,  characters: characters)
                //print("TITULO PELICULA: \(film.title)")
                
                //arrayFilms += [film]
                //print("El array vale: \(arrayFilms.count)")
                completion(film, successCount)
            } catch {
                successCount -= 1
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
    
} // End - getArrayOfFilms
