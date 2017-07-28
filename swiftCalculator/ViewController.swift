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
            numberDisplay.text = String(newValue).truncate(length: 10, trailing: "")
        }
    }
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if userIsTypingANumber {
            if numberDisplay.text!.count < 10 {
                numberDisplay.text = numberDisplay.text! + sender.currentTitle!
            }
        } else {
            numberDisplay.text = sender.currentTitle!.truncate(length: 10, trailing: "")
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
        if let result = calculator.result {
            displayNumberValue = result
        }
    }
    
    
    
    
    
    
}

extension String {
    func truncate(length: Int, trailing: String = "") -> String {
        if self.characters.count > length {
            return String(self.characters.prefix(length)) + trailing
        } else {
            return self
        }
    }
    
}

