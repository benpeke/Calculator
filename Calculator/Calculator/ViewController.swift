//
//  ViewController.swift
//  Calculator
//
//  Created by Benjamin Schwartz on 1/28/15.
//  Copyright (c) 2015 Benjamin Schwartz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var brain = CalculatorBrain()

    var displayValue:Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTyping = false
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        historyDisplay.text = historyDisplay.text! + digit
        if (digit != "." || display.text!.rangeOfString(".") != nil) {
            if (userIsInTheMiddleOfTyping) {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTyping = true
            }
        }
    }

    @IBAction func clear(sender: UIButton) {
        brain.clear()
        display.text = "0"
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        historyDisplay.text = historyDisplay.text! + operation
        if (userIsInTheMiddleOfTyping) {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
}
