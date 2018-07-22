//
//  Film.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 20/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import Foundation
import UIKit

/*
struct Film : Decodable {
    
    let title : String
    /*let episode_id : Int
    let opening_crawl : String
    let director : String
    let producer : String
    let release_date : String
    let created : String
    let edited : String*/
    //let image : UIImage
    
}*/

class Film {
    
    var title : String
    var opening_crawl: String
    var release_date: String
    var episode: Int
    var image : UIImage
    
    init(title: String, description: String, year: String, episode: Int, image: UIImage) {
        self.title = title
        self.opening_crawl = description
        self.release_date = year
        self.episode = episode
        self.image = image
    }
    
}


// MARK: - Get JSON from StarWars API

// ---------------------------------------------------------------------------------

func getNumberOfObjects(nameResource: String, arrayFilms : [Film], completion: @escaping (Int?) -> Void ) {
    
    // let urlString = "https://swapi.co/api/people/?format=json&search=\(name)"
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

func getArrayOfFilms(numberOfFilms : Int, completion: @escaping (Film?) -> Void ) {
    
    for value in 1...numberOfFilms {
        
        let urlString = "https://swapi.co/api/films/\(value)/?format=json"
        
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
                let dataFilm = try JSONSerialization.jsonObject(with: datos) as! [String:Any]
                
                // Obtenemos los valores del diccionario
                let title = dataFilm["title"] as! String
                let description = dataFilm["opening_crawl"] as! String
                let episode = dataFilm["episode_id"] as! Int
                let image = UIImage(named: "film\(episode)")
                
                var year = dataFilm["release_date"] as! String
                // Convertimos la fecha: yyyy-MM-dd => dd-MM-yyyy
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: year)
                dateFormatter.dateFormat = "dd-MM-yyyy"
                year = dateFormatter.string(from: date!)
                
                year = "Premiere: " + year
                
                
                // Almacenamos los valores obtenidos en una instancia de Film
                let film = Film(title: title, description: description, year: year, episode: episode, image: image!)
                //print("TITULO PELICULA: \(film.title)")
                
                //arrayFilms += [film]
                //print("El array vale: \(arrayFilms.count)")
                completion(film)
            } catch {
                debugPrint(error)
            }
        }
        
        // And finally send it
        task.resume()
    }
}
