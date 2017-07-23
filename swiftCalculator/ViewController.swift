//
//  ViewController.swift
//  swiftCalculator
//
//  Created by Taylor on 2017-07-22.
//  Copyright © 2017 Taylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberDisplay: UILabel!
    var userIsTypingANumber = false
    
    var displayNumberValue: Double {
        get {
            return Double(numberDisplay.text!)!
        }
        set {
            numberDisplay.text = String(newValue)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if userIsTypingANumber {
            numberDisplay.text = numberDisplay.text! + sender.currentTitle!
        } else {
            numberDisplay.text = sender.currentTitle!
            userIsTypingANumber = true
        }
        
        
    }
    
    private var calculator = CalculatorModel()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTypingANumber {
            calculator.setDisplayValue(displayNumberValue)
        }
        userIsTypingANumber = false
        if let mathematicalSymbol = sender.currentTitle {
            calculator.performOperation(mathematicalSymbol)
        }
        
    }

    
    
    
    
    
}


