//
//  ViewController.swift
//  Calculator
//
//  Created by Ashok on 3/22/17.
//  Copyright © 2017 Ashok. All rights reserved.
//Add a line.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
 
    var userIsInMiddleOfTyping = false

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle
        
        if userIsInMiddleOfTyping{
            display.text = display.text! + digit!
        }
        else{
            display.text = digit!
            userIsInMiddleOfTyping = true
            
        }
        
    }

    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInMiddleOfTyping{
            
            brain.setOperand(displayValue)
            userIsInMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result{
            displayValue = result
        }
    }
}

