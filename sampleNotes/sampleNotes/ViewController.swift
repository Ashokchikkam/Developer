//
//  ViewController.swift
//  sampleNotes
//
//  Created by Ashok on 2/28/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: Properties

    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var infoTextView: UITextView!
    
    /*
     This value is either passed by `DataTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new notes.
     */
    var data: DataModel?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddnotesMode = presentingViewController is UINavigationController
      
        if isPresentingInAddnotesMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ViewController is not inside a navigation controller.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up views if editing an existing Meal.
        if let data = data {
            
            navigationItem.title = data.title
            titleTextField.text = data.title
            infoTextView.text = data.info
            
        }
        
        titleTextField.delegate = self
        infoTextView.delegate = self
        
        // Enable the Save button only if the text field has a valid notes name.
        updateSaveButtonState()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let title = titleTextField.text ?? ""
        let info = infoTextView.text
        
        data = DataModel(title: title, info: info)
        
    }

    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateSaveButtonState()
        navigationItem.title = textField.text
      //  titleTextField.isEnabled = false
        
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
        
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

