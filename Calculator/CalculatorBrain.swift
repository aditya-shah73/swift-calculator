//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Aditya Shah on 2/14/17.
//  Copyright © 2017 San Jose State University. All rights reserved.
//

import Foundation

enum Optional<T>{
    case None
    case Some(T)
}

class CalculatorBrain{
    
    private var accumulator = 0.0
    
    func setOperand(operand:Double){
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "∏": Operation.Constant(M_PI), // M_PI
        "e": Operation.Constant(M_E), // M_E
        "±": Operation.UnaryOperation({ -$0 }),
        "√": Operation.UnaryOperation(sqrt), // sqrt
        "cos": Operation.UnaryOperation(cos), //cosine
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "×": Operation.BinaryOperation({$0 * $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
        "/": Operation.BinaryOperation({$0 / $1}),
        "SQ": Operation.UnaryOperation({$0 * $0}),
        "CU": Operation.UnaryOperation({$0 * $0 * $0}),
        "=": Operation.Equals
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction:function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo{
        var binaryFunction:(Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
}
