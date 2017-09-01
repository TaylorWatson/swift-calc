//
//  RoundLabel.swift
//  swiftCalculator
//
//  Created by Taylor on 2017-07-28.
//  Copyright © 2017 Taylor. All rights reserved.
//

import UIKit

class RoundLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

}

