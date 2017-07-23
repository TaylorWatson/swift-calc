//
//  ViewController.swift
//  swiftCalculator
//
//  Created by Taylor on 2017-07-22.
//  Copyright © 2017 Taylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel?
    
    var userIsTypingANumber = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTypingANumber {
            let textCurrentlyInDisplay = display!.text!
            display!.text = textCurrentlyInDisplay + digit
        } else {
            display!.text = digit
            userIsTypingANumber = true
        }
        
        
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        userIsTypingANumber = false
        if let mathematicalSymbol = sender.currentTitle {
            switch mathematicalSymbol {
            case "π":
                display!.text = String(Double.pi)
            default:
                break
            }
        }
    }

}


