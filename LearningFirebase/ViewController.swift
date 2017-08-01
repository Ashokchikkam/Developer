//
//  ViewController.swift
//  LearningFirebase
//
//  Created by Ashok on 7/30/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import Firebase

import FirebaseDatabase

class ViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        self.ref.child("Users").setValue(["Time": "12:34", "Lat": "5678", "Long": "9876"])
        
      //  retrieveData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerBtnPressed(_ sender: Any) {
        
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion:{ (user, error) in
            if error != nil{
                print(error)
                return
            }
            
            let userID = user?.uid
            
            let userEmail = self.email.text!
            let userPassword = self.password.text!
            
            self.ref.child("Users").child(userID!).setValue(["Email": userEmail, "Password": userPassword])
            
            print("user registered with Firebase with a uid of:\(String(describing: user?.uid))")
        })
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: {(user,error) in
            if error != nil{
                print(error)
                return
            }
            print("user logged-in with Firebase with a uid of:\(String(describing: user?.uid))")
            
        })
    }
    
    func retrieveData(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        if uid != nil{
            print("current user id:\(String(describing: uid))")
            
            ref.child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let email = value?["Email"] as! String
                let password = value?["Password"] as! String
                
                print("Retrieving data from database Email:\(email) and Password: \(password)")
            })
        }
    }
}

