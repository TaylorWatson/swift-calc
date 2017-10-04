//
//  CalculatorModel.swift
//  swiftCalculator
//
//  Created by Taylor on 2017-07-22.
//  Copyright © 2017 Taylor. All rights reserved.
//

import Foundation

struct CalculatorModel {
    
    
    private var accumulator: (Double, String)?
    var descriptionAccumulator: String?
    var runningDescriptionAccumulator: String?
    var unaryOpSymbolInDescription : Bool?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var firstDescription: String
        var descriptionFunction: (String, String) -> String
        
        
        func perform(with secondOperand: Double) -> Double {
            return binaryFunction(firstOperand, secondOperand)
        }
        func performDescription(with secondDescription: String) -> String {
            return descriptionFunction(firstDescription, secondDescription)
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    // Calculated Properties
    
    var resultIsPending : Bool {
        get {
            return pending != nil
        }
    }
    
    var equalOrEllipsis: String? {
        get {
            return resultIsPending ? " ..." : " ="
        }
    }
    
    private mutating func addToPendingBinaryOperation() {
        if descriptionAccumulator != nil {
            runningDescriptionAccumulator = pending!.descriptionFunction(pending!.firstDescription, String(accumulator!))
        }
        accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator!)
    }
    
    
    mutating func executePendingBinaryOperation() {
        if descriptionAccumulator != nil {
            descriptionAccumulator = pending!.descriptionFunction(pending!.firstDescription, String(accumulator!))
            
        }
        accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator!)
    }
    
    // format number to display 4, 4.44 or 44444.4444 only.
    func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 0
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 5
        return formatter.string(from: value as NSNumber)!
    }
    
    private enum Operation {
        case constant(Double, String)
        case unary((Double) -> Double, (String) -> String)
        case binary((Double, Double) -> Double, (String, String) -> String)
        case equals
        case backspace
    }
    
    private var operations: Dictionary<String,Operation> = [
        "𝛑" : Operation.constant(Double.pi, "𝛑"),
        "e" : Operation.constant(M_E, "e"),
        "√" : Operation.unary(sqrt, { "√(\($0))" }),
        "cos" : Operation.unary(cos, { "cos \($0)" }),
        "±" : Operation.unary({ -$0 }, { "-\($0)" }),
        "10%" : Operation.unary({ $0 * 1.1 }, { "\($0) + 10%" }),
        "SqYd" : Operation.unary({ $0 / 9 }, { "\($0) SqYds" }),
        "Tax" : Operation.unary({ $0 * 1.13 }, { "\($0) + 13%" }),
        "﹪" : Operation.unary({ $0 / 100 }, { "\($0) / 100" }),
        "×" : Operation.binary({ $0 * $1 }, { "\($0) × \($1)" }),
        "÷" : Operation.binary({ $0 / $1 }, { "\($0) ÷ \($1)" }),
        "+" : Operation.binary({ $0 + $1 }, { "\($0) + \($1)" }),
        "-" : Operation.binary({ $0 - $1 }, { "\($0) - \($1)" }),
        "=" : Operation.equals,
        "⌫" : Operation.backspace
    ]
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var descriptionResult: String? {
        get {
            return descriptionAccumulator
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
        
            case .constant(let accumulatorValue):
                // rounding constant values to 4 decimal places
                accumulator = (value, symbol)
                
            case .unary(let function, let descriptionFunction):
                if accumulator != nil {
                    accumulator = (function(accumulator!.0), descriptionFunction(accumulator!.1))
                }
                
            case .binary(let function, let descriptionFunction):
                resultIsPending ? addToPendingBinaryOperation() : nil
                if accumulator != nil
                {
                    pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator!, firstDescription: resultIsPending ? runningDescriptionAccumulator! : unaryOpSymbolInDescription == true ? descriptionAccumulator! : String(accumulator!), descriptionFunction: descriptionFunction)
                    unaryOpSymbolInDescription = nil
                    descriptionAccumulator = pending!.performDescription(with: equalOrEllipsis!)
                }
               
            case .equals:
                if resultIsPending {
                    executePendingBinaryOperation()
                    pending = nil
                    descriptionAccumulator = descriptionAccumulator! + equalOrEllipsis!
                }
            case .backspace:
                if let accumulatorString = accumulator {
                    accumulatorString
                }
            } 
        }
    }
    mutating func clearCalculator() {
        accumulator = nil
        descriptionAccumulator = nil
        pending = nil
    }
    
    mutating func setDisplayValue(_ displayValue: Double) {
        accumulator = displayValue
        descriptionAccumulator = String(displayValue)
    }
    
}


