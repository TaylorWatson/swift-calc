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
    @IBOutlet weak var descriptionDisplay: UILabel!
    //is the user in the middle of typing
    var userIsTypingANumber = false
    //how many chars before numberDisplay stops typing
    let displayStringLength = 11
    
    var displayDescriptionValue: String {
        get{
            return descriptionDisplay.text!
        }
        set {
            descriptionDisplay.text = String(newValue)
        }
    }
    
    var displayNumberValue: Double {
        get {
            return Double(numberDisplay.text!)!
        }
        set {
            numberDisplay.text = calculator.formatNumber(newValue)
        }
    }
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        buttonBounce(sender)
        let digit = sender.currentTitle!
        if userIsTypingANumber {
            if (digit == ".") && ((numberDisplay.text!.range(of: ".") != nil)) {
                return
            }
            let textCurrentlyInDisplay = numberDisplay.text!
            numberDisplay.text = textCurrentlyInDisplay + digit
        } else {
            if digit == "." {
                numberDisplay.text = "0."
            }  else {
                numberDisplay.text = digit
            }
            userIsTypingANumber = true
        }
  
    }
    
    
    
    // clear the calculator
    @IBAction func touchClear(_ sender: UIButton) {
        buttonBounce(sender)
        calculator.clearCalculator()
        displayNumberValue = 0
        displayDescriptionValue = ""
    }
    
    private var calculator = CalculatorModel()
    
    @IBAction func performOperation(_ sender: UIButton) {
        buttonBounce(sender)
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
        if let description = calculator.descriptionResult {
            displayDescriptionValue = description
        }
    }
    
    
    
    func buttonBounce(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.30),
                       initialSpringVelocity: CGFloat(3.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
    
    
}
