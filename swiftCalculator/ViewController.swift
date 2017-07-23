//
//  ViewController.swift
//  swiftCalculator
//
//  Created by Taylor on 2017-07-22.
//  Copyright © 2017 Taylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func touchDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle{
            print("\(digit) was pressed")
        }
        
    }
    

}

