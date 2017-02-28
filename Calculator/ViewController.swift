//
//  ViewController.swift
//  Calculator
//
//  Created by Aditya Shah on 1/31/17.
//  Copyright © 2017 San Jose State University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBOutlet private weak var history: UILabel!
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let historyDisplay = history!.text!
        history!.text! = historyDisplay + digit
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display!.text!
            display!.text = textCurrentlyInDisplay + digit
        }
        else{
            display!.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction func memoryOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let memorySym = sender.currentTitle{
            brain.performMemory(symbol: memorySym)
        }
        displayValue = brain.result
    }
    
    var decimalIsPressed = false

    @IBAction func floatingPoint(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = true
        if decimalIsPressed == false {
            display.text = display.text! + "."
            decimalIsPressed = true
        }
    }
        
    private var displayValue: Double{
        get{
            return Double(display.text!)!
            
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        let operation = sender.currentTitle!
        let historyDisplay = history!.text!
        decimalIsPressed = false
        history!.text! = historyDisplay + operation
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
}
