//
//  ViewController.swift
//  ToDoList
//
//  Created by Ashok on 3/17/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var saveButtonTitle: UIBarButtonItem!
    
    var itemToEdit: Item?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("called")
        //print("asmcnbasmxbsamncx")
        titleField.delegate = self
        saveButtonTitle.isEnabled = false

        if itemToEdit != nil {
            loadItemData()
            saveButtonTitle.title = "Update"
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        updateSaveButtonState()

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UITextFieldDelegate
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButtonTitle.isEnabled = false
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        var item: Item!
        
        // checking if its a new item or an existing item.
        if itemToEdit == nil{
            item = Item(context: context)
        }
        else{
            item = itemToEdit
        }
        
        if let title = titleField.text{
            item.title = title
        }
        if let description = descriptionField.text{
            item.descrip = description
        }
        
        ad.saveContext()
        
        //to dismiss the detail vc
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
       // dismiss(animated: true, completion: nil)
        
    }
    @IBAction func DeleteBtnPressed(_ sender: UIBarButtonItem) {
        
        print("delete button pressed")
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
            
            print("deleting from DB")
            
        }
        
        _ = navigationController?.popViewController(animated: true)
//
//        let isPresentingInAddMealMode = presentingViewController is UINavigationController
//        
//        if isPresentingInAddMealMode {
//            dismiss(animated: true, completion: nil)
//        }
//        else if let owningNavigationController = navigationController{
//            owningNavigationController.popViewController(animated: true)
//        }
//        else {
//            fatalError("The MealViewController is not inside a navigation controller.")
//        }
        print("dismissing DetailVC")
        
    }
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        _ = navigationController?.popViewController(animated: true)
        
//        let isPresentingInAddMealMode = presentingViewController is UINavigationController
//        
//        if isPresentingInAddMealMode {
//            dismiss(animated: true, completion: nil)
//        }
//        else if let owningNavigationController = navigationController{
//            owningNavigationController.popViewController(animated: true)
//        }
//        else {
//            fatalError("The MealViewController is not inside a navigation controller.")
//        }
    }
    
    func loadItemData(){
        
        if let item = itemToEdit{
            
            navigationItem.title = item.title
            
            titleField.text = item.title
            descriptionField.text = item.descrip
            //print("asmcnbasmxbsamncx")
            
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = titleField.text
        
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = titleField.text ?? ""
        print("\(text)")
        saveButtonTitle.isEnabled = !text.isEmpty
    }
    
    
}

