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
    var descriptionAccumulator: String?
    var oldAccumulator: Double?
    var isOldAccumulatorSet: Bool?
    var operationHasChanged: Bool?
    var oldSymbol: String?
    
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
    
   
    private mutating func addToPendingBinaryOperation() {
        if descriptionAccumulator != nil {
            descriptionAccumulator = pending!.descriptionFunction(pending!.firstDescription, String(oldAccumulator!))
        }
        accumulator = pending!.binaryFunction(pending!.firstOperand, oldAccumulator!)
    }
    
    
    mutating func executePendingBinaryOperation() {
        if descriptionAccumulator != nil {
            descriptionAccumulator = pending!.descriptionFunction(pending!.firstDescription, String(accumulator!))
        }
        isOldAccumulatorSet = nil
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
    }
    
    private var operations: Dictionary<String,Operation> = [
        "𝛑" : Operation.constant(Double.pi, "𝛑"),
        "e" : Operation.constant(M_E, "e"),
        "√" : Operation.unary(sqrt, { "√(\($0))" }),
        "cos" : Operation.unary(cos, { "cos \($0)" }),
        "±" : Operation.unary({ -$0 }, { "-\($0)" }),
        "+10%" : Operation.unary({ $0 * 1.1 }, { "\($0) + 10%" }),
        "-10%" : Operation.unary({ $0 * 0.9 }, { "\($0) - 10%" }),
        "Tax" : Operation.unary({ $0 * 1.13 }, { "\($0) + 13%" }),
        "﹪" : Operation.unary({ $0 / 100 }, { "\($0) / 100" }),
        "×" : Operation.binary({ $0 * $1 }, { "\($0) × \($1)" }),
        "÷" : Operation.binary({ $0 / $1 }, { "\($0) ÷ \($1)" }),
        "+" : Operation.binary({ $0 + $1 }, { "\($0) + \($1)" }),
        "-" : Operation.binary({ $0 - $1 }, { "\($0) - \($1)" }),
        "=" : Operation.equals
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
        
            case .constant(let accumulatorValue, let descriptionValue):
                // rounding constant values to 4 decimal places
                accumulator = Double(floor(10000*accumulatorValue)/10000)
                descriptionAccumulator = descriptionValue
                // should be working fine.
                
            case .unary(let function, let descriptionFunction):
                if accumulator != nil {
                    if descriptionAccumulator != nil {
                        descriptionAccumulator = descriptionFunction(descriptionAccumulator!)
                    } else {
                        descriptionAccumulator = descriptionFunction(String(accumulator!))
                    }
                    //rounding unary operation result to 5 decimal places
                    accumulator = Double(floor(100000*function(accumulator!))/100000)
                }
                // should be working fine.
                
            case .binary(let function, let descriptionFunction):
               /*
                 if oldSymbol == nil {
                    oldSymbol = symbol
                } else if oldSymbol != symbol {
                    operationHasChanged = true
                }
               */
                // if != nil means someone has hit a binary button again. EG: 5 + 5 + ...
                if pending != nil {
                    if isOldAccumulatorSet == nil {
                        oldAccumulator = accumulator
                        isOldAccumulatorSet = true
                    }
                    // if operationHasChanged skip func. EG: 5 + 5 - ...
                    if operationHasChanged == nil {
                        addToPendingBinaryOperation()
                    }
                }
                if accumulator != nil {
                    pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator!, firstDescription:  String(accumulator!), descriptionFunction: descriptionFunction)
                }
                
            case .equals:
                if pending != nil {
                    executePendingBinaryOperation()
                }
                pending = nil
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


