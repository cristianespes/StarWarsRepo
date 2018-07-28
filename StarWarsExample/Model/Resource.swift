//
//  Resource.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 20/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import Foundation

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
