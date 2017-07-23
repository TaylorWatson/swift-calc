//
//  CalculatorModel.swift
//  swiftCalculator
//
//  Created by Taylor on 2017-07-22.
//  Copyright © 2017 Taylor. All rights reserved.
//

import Foundation

struct CalculatorModel {
    
    private var accumulator: Double?
    
    func performOperation(_ symbol: String) {
   
    }
    
    mutating func setDisplayValue(_ displayValue: Double) {
        accumulator = displayValue
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
  
