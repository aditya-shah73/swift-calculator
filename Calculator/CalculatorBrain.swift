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
    private var cleared = false
    private var internalProgram = [Any]()
    
    func setOperand(operand:Double){
        accumulator = operand
        internalProgram.append(operand as AnyObject)
        cleared = false
    }
    
    private var operations: Dictionary<String, Operation> = [
        "∏": Operation.Constant(M_PI), // M_PI
        "e": Operation.Constant(M_E), // M_E
        "±": Operation.UnaryOperation({ -$0 }),
        "√": Operation.UnaryOperation(sqrt), // sqrt
        "cos": Operation.UnaryOperation(cos), //cosine
        "sin": Operation.UnaryOperation(sin), //sine
        "tan": Operation.UnaryOperation(tan), //tan
        "×": Operation.BinaryOperation({$0 * $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
        "/": Operation.BinaryOperation({$0 / $1}),
        "x²": Operation.UnaryOperation({$0 * $0}),
        "x³": Operation.UnaryOperation({$0 * $0 * $0}),
        "=": Operation.Equals,
        "AC": Operation.AllClear
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case AllClear
    }
    
    private var memory = 0.0
    
    func performMemory(symbol: String?){
        if let memOperation = symbol{
            switch memOperation {
            case "MR":
                accumulator = memory
            case "MS":
                memory = accumulator
            case "MC":
                memory = 0.0
            case "M+":
                memory = accumulator + memory
            default:
                break
            }
        }
    }
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction:function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .AllClear:
                clearCalc()
            }
        }
    }
    
    private func clearCalc(){
        if cleared{ //all cleared
            pending = nil
            accumulator = 0.0
            pending?.firstOperand = 0.0
            cleared = false
        }
        else{ //clear
            accumulator = 0.0
            cleared = true
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
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
}
