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
