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
