//
//  Resource.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 20/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import Foundation
import UIKit

struct Resource : Decodable {
    let count : Int
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

// ---------------------------------------------------------------------------------

func convertStringToInt(string: String) -> Int {
    
    var number : Int = 0
    
    if let numberValue = Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
        number = numberValue
    }
    
    return number
}

// ---------------------------------------------------------------------------------

func convertArrayIntToString(arrayOfInt: [Int]) -> [String] {
    
    var arrayOfString : [String] = []
    
    for value in arrayOfInt {
        arrayOfString += ["\(value)"]
    }
    
    return arrayOfString
}

// ---------------------------------------------------------------------------------

// Método para mostrar alertas
func showAlert(vc: UIViewController, message: String){
    let alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}

// ---------------------------------------------------------------------------------

// Método para ocultar refresher
func hideRefresher(refresher: UIRefreshControl) {
    // Ocultamos la ruleta
    let deadline = DispatchTime.now() + .milliseconds(500)
    DispatchQueue.main.asyncAfter(deadline: deadline) {
        // Finalizamos el UIRefreshControl
        refresher.endRefreshing()
    }
}

// ---------------------------------------------------------------------------------

// MARK: - Activity Indicator

// Método para arrancar el Activity Indicator
func startActivityIndicator(activityIndicator: UIActivityIndicatorView, view: UIView, tableView: UITableView) {
    
    // Posicionar el Activity Indicator en el centro de la vista
    if #available(iOS 11.0, *) {
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: UIScreen.main.bounds.height/3)
    } else {
        activityIndicator.center = view.center
    }
    
    // Ocultar cuando se detenga la animación
    activityIndicator.hidesWhenStopped = true
    
    // Arrancar la animación
    activityIndicator.startAnimating()
    
    // Añadir el Activity Indicator a la vista
    view.addSubview(activityIndicator)
}

// ---------------------------------------------------------------------------------
// MARK: - Get JSON from StarWars API

func getNumberOfObjects(nameResource: String, arrayObject : [AnyObject], completion: @escaping (Int?) -> Void ) {
    
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
// MARK: - Apply .uppercaseString to only the first letter of a string

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

// ---------------------------------------------------------------------------------

// MARK: - Download image from URL

extension UIImageView {
    
    // Método para descargar una Imagen dada una URL, hace falta añadir otra imagen en caso de fallo (placeholder)
    func getImgFromUrl(link: String, placeholder: UIImage, index: Int,  completion: ((_ image: UIImage, _ index: Int) -> Void)? = nil ) {
        
        guard let url = NSURL(string: link) else { return }
        
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, _, error) -> Void in
            
            // Check if any error exists
            if error != nil {
                DispatchQueue.main.async() { () -> Void in
                    self.image = placeholder
                }
                return
            }
            
            guard let image = UIImage(data: data!) else {
                DispatchQueue.main.async() { () -> Void in
                    self.image = placeholder
                }
                return
            }
            
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                completion?(image, index)
            }
            
        }).resume()
    }

}

// ---------------------------------------------------------------------------------

// MARK: - Devolver episodio según la película

func setTitleByFilm(film: Int) -> String {
    switch film {
    case 4:
        return "Episode I"
    case 5:
        return "Episode II"
    case 6:
        return "Episode III"
    case 1:
        return "Episode IV"
    case 2:
        return "Episode V"
    case 3:
        return "Episode VI"
    case 7:
        return "Episode VII"
    case 8:
        return "Episode VIII"
    case 9:
        return "Episode IX"
    default:
        return ""
    }
}
