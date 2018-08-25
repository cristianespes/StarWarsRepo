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
    let director: String
    let producer: String
    let planets: [Int]
    
    
    init(title: String, description: String, year: String, episode: Int, image: UIImage, url : Int, characters: [Int], director: String, producer: String, planets: [Int]) {
        self.title = title
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
                    completion(nil, successCount)
                    return
                }
                
                // Obtenemos los valores del diccionario
                let title = dataFilm["title"] as! String
                let description = dataFilm["opening_crawl"] as! String
                let episode = dataFilm["episode_id"] as! Int
                let director = dataFilm["director"] as! String
                let producer = dataFilm["producer"] as! String
                let auxURL = dataFilm["url"] as! String
                let url = convertStringToInt(string: auxURL)
                
                // Recogemos los personajes de la película
                let auxCharacters = dataFilm["characters"] as! [String]
                var characters : [Int] = []
                for value in auxCharacters {
                    characters += [convertStringToInt(string: value)]
                }
                
                // Recogemos los planetas de la película
                let auxPlanets = dataFilm["planets"] as! [String]
                var planets : [Int] = []
                for value in auxPlanets {
                    planets += [convertStringToInt(string: value)]
                }
                
                // let image = UIImage(named: "film\(episode)")
                // Descarga la imagen desde Internet
                var image = #imageLiteral(resourceName: "filmIcon") // Imagen por defecto
                if let url = URL(string: showFilmFromUrl(filmEpisode: episode)) {
                    do {
                        let data = try Data(contentsOf: url)
                        guard let downloadImage = UIImage(data: data) else { return }
                        image = downloadImage
                        
                    } catch let error {
                        print("Error al descargar la imagen de \(episode): \(error.localizedDescription)")
                    }
                }
                
                
                var year = dataFilm["release_date"] as! String
                // Convertimos la fecha: yyyy-MM-dd => dd-MM-yyyy
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: year)
                dateFormatter.dateFormat = "MM-dd-yyyy"
                year = dateFormatter.string(from: date!)
                
                
                // Almacenamos los valores obtenidos en una instancia de Film
                let film = Film(title: title, description: description, year: year, episode: episode, image: image, url: url,  characters: characters, director: director, producer: producer, planets: planets)

                
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

// ---------------------------------------------------------------------------------

// MARK: - Download Image from URL as per the planet name

func showFilmFromUrl(filmEpisode: Int) -> String {
    
    switch filmEpisode {
    case 1:
        return "https://lumiere-a.akamaihd.net/v1/images/Star-Wars-Phantom-Menace-I-Poster_3c1ff9eb.jpeg?region=15%2C9%2C651%2C979&width=480"
    case 2:
        return "https://lumiere-a.akamaihd.net/v1/images/Star-Wars-Attack-Clones-II-Poster_53baa2e7.jpeg?region=18%2C0%2C660%2C1000&width=480"
    case 3:
        return "https://lumiere-a.akamaihd.net/v1/images/Star-Wars-Revenge-Sith-III-Poster_646108ce.jpeg?region=0%2C0%2C736%2C1090&width=480"
    case 4:
        return "https://lumiere-a.akamaihd.net/v1/images/Star-Wars-New-Hope-IV-Poster_c217085b.jpeg?region=49%2C43%2C580%2C914&width=480"
    case 5:
        return "https://lumiere-a.akamaihd.net/v1/images/Star-Wars-Empire-Strikes-Back-V-Poster_878f7fce.jpeg?region=25%2C22%2C612%2C953&width=480"
    case 6:
        return "https://lumiere-a.akamaihd.net/v1/images/Star-Wars-Return-Jedi-VI-Poster_a10501d2.jpeg?region=12%2C9%2C618%2C982&width=480"
    case 7:
        return "https://lumiere-a.akamaihd.net/v1/images/avco_payoff_1-sht_v7_lg_32e68793.jpeg?width=480"
    case 8:
        return "https://lumiere-a.akamaihd.net/v1/images/the-last-jedi-theatrical-poster-film-page_bca06283.jpeg"
    default:
        return ""
    }
    
}
