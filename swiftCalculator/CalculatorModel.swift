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
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var operations: Dictionary<String,Operation> = [
        "𝛑" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unary(sqrt),
        "cos" : Operation.unary(cos),
        "±" : Operation.unary({ -$0 }),
        "10%" : Operation.unary({ $0 * 1.1 }),
        "﹪" : Operation.unary({ $0 / 100 }),
        "×" : Operation.binary({ $0 * $1 }),
        "÷" : Operation.binary({ $0 / $1 }),
        "+" : Operation.binary({ $0 + $1 }),
        "-" : Operation.binary({ $0 - $1 }),
        "=" : Operation.equals,
        "C" : Operation.clear
    ]
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unary(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binary(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                accumulator = nil
            }
        }
    }
    
    mutating func setDisplayValue(_ displayValue: Double) {
        accumulator = displayValue
    }
    
    
    
}

