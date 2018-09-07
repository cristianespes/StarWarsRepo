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
    
    // Mark: - Properties
    let title : String
    let subtitle : String
    let opening_crawl: String
    let release_date: String
    let episode: Int
    var image : UIImage
    let url : Int
    let characters: [Int]
    let director: String
    let producer: String
    let planets: [Int]
    
    // Mark: - Initializations
    init(title: String, subtitle : String, description: String, year: String, episode: Int, image: UIImage, url : Int, characters: [Int], director: String, producer: String, planets: [Int]) {
        self.title = title
        self.subtitle = subtitle
        self.opening_crawl = description
        self.release_date = year
        self.episode = episode
        self.image = image
        self.url = url
        self.characters = characters
        self.director = director
        self.producer = producer
        self.planets = planets
    }
    
} // End - class Film
// ---------------------------------------------------------------------------------

func returnArrayOfAllFilmsFromData(result: [AnyObject]) -> [Film] {
    
    var arrayOfFilms : [Film] = []
    
    for object in result {
        
        // Obtenemos los valores del diccionario
        let title = object["title"] as! String
        let subtitle = object["subtitle"] as! String
        let description = object["opening_crawl"] as! String
        let auxEpisode = object["episode"] as! String
        let episode = convertStringToInt(string: auxEpisode)
//        let auxFilm = object["film"] as! String
//        let filmNumber = convertStringToInt(string: auxFilm)
        let director = object["director"] as! String
        let producer = object["producer"] as! String
        let auxUrl = object["director"] as! String
        let url = convertStringToInt(string: auxUrl)
        
        var year = object["release_date"] as! String
        if year != "" {
            // Convertimos la fecha: yyyy-MM-dd => dd-MM-yyyy
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: year)
            dateFormatter.dateFormat = "MM-dd-yyyy"
            year = dateFormatter.string(from: date!)
            } else {
            year = "XX-XX-XXXX"
        }
        
        // Recogemos los planetas de la película
        let auxCharacters = object["characters"] as! [String]
        var characters : [Int] = []
        for value in auxCharacters {
            characters += [convertStringToInt(string: value)]
        }
        characters.sort{ $0 < $1 }
        
        // Recogemos los planetas de la película
        let auxPlanets = object["planets"] as! [String]
        var planets : [Int] = []
        for value in auxPlanets {
            planets += [convertStringToInt(string: value)]
        }
        planets.sort{ $0 < $1 }
        
        // Descarga la imagen desde Internet
        var image = #imageLiteral(resourceName: "filmIcon") // Imagen por defecto
        let imageUrl = object["image"] as! String
        if let url = URL(string: imageUrl) {
            do {
                let data = try Data(contentsOf: url)
                if let downloadImage = UIImage(data: data) {
                    image = downloadImage
                }
                
            } catch let error {
                print("Error al descargar la imagen de \(title): \(error.localizedDescription)")
            }
        }
        
        let film = Film(title: title, subtitle: subtitle, description: description, year: year, episode: episode, image: image, url: url, characters: characters, director: director, producer: producer, planets: planets)
        
        arrayOfFilms.append(film)
    }
    
    return arrayOfFilms
    
}
