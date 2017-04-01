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
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var addNotes: UIButton!
    
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("called")
        //print("asmcnbasmxbsamncx")
        titleField.delegate = self
        saveButtonTitle.isEnabled = false

        

        
        if itemToEdit != nil {
            saveButtonTitle.isEnabled = false
            saveButtonTitle.title = "Update"
            loadItemData()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        //updateSaveButtonState()
        

        self.titleField.becomeFirstResponder()
    }
    
    @IBAction func addNotes(_ sender: UIButton) {
        
        innerView.isHidden = true
        addNotes.isHidden = true
        
        self.descriptionField.becomeFirstResponder()
        
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
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            //print("Send now button tapped for value")
            if self.itemToEdit != nil {
                context.delete(self.itemToEdit!)
                ad.saveContext()

                print("deleting from DB")
                
            }
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
            //self.myTableView.setEditing(false, animated: true)
        })
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
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(deleteButton)
        
        alertController.addAction(cancelButton)
        
        //self.navigationController?.presentingViewController(alertController, animated: true)
        self.navigationController!.present(alertController, animated: true, completion: nil)
        //self.presentingViewController(alertController)
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
            
            if descriptionField.text != ""{
                innerView.isHidden = true
                addNotes.isHidden = true
               // descriptionField.becomeFirstResponder()
            }
            
            //print("asmcnbasmxbsamncx")
            
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = titleField.text
        let text = titleField.text ?? ""
        print("\(text)")
        saveButtonTitle.isEnabled = !text.isEmpty
        
    }
//    
//    func displayShareSheet()
//    {
//        
//        //let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .ActionSheet)
//        
//        let shareViaFacebook = UIAlertAction(title: "Share via Facebook", style: .Default, handler: { (action) -> Void in
//            print("Send now button tapped for value")
//        })
//        
//        let shareViaEmail = UIAlertAction(title: "Share via Email", style: .Default, handler: { (action) -> Void in
//            print("Delete button tapped for value")
//        })
//        
//        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
//            print("Cancel button tapped")
//            self.myTableView.setEditing(false, animated: true)
//        })
//        
//        alertController.addAction(shareViaFacebook)
//        alertController.addAction(shareViaEmail)
//        alertController.addAction(cancelButton)
//        
//        self.navigationController!.presentViewController(alertController, animated: true, completion: nil)
//    }
//    
//

}

