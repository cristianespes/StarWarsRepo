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
    let id : Int
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
    init(id: Int, title: String, subtitle : String, description: String, year: String, episode: Int, image: UIImage, url : Int, characters: [Int], director: String, producer: String, planets: [Int]) {
        self.id = id
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
    
    return result.map {
        
        // Obtenemos los valores del diccionario
        let id = $0["id"] as! Int
        let title = $0["title"] as! String
        let subtitle = $0["subtitle"] as! String
        let description = $0["opening_crawl"] as! String
        let auxEpisode = $0["episode"] as! String
        let episode = convertStringToInt(string: auxEpisode)
//        let auxFilm = object["film"] as! String
//        let filmNumber = convertStringToInt(string: auxFilm)
        let director = $0["director"] as! String
        let producer = $0["producer"] as! String
        let auxUrl = $0["url"] as! String
        let url = convertStringToInt(string: auxUrl)
        
        var year = $0["release_date"] as! String
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
        
        // Recogemos los personajes de la película
        let auxCharacters = $0["characters"] as! [String]
        let characters = auxCharacters.compactMap { convertStringToInt(string: $0) }.sorted()
        
        // Recogemos los planetas de la película
        let auxPlanets = $0["planets"] as! [String]
        let planets : [Int] = auxPlanets.compactMap { convertStringToInt(string: $0) }.sorted()
        
        // Descarga la imagen desde Internet
        var image = #imageLiteral(resourceName: "filmIcon") // Imagen por defecto
        let imageUrl = $0["image"] as! String
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
        
        let film = Film(id: id, title: title, subtitle: subtitle, description: description, year: year, episode: episode, image: image, url: url, characters: characters, director: director, producer: producer, planets: planets)
        
        return film
    }
    
}
