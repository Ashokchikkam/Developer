//
//  MainTableVC.swift
//  ToDoList
//
//  Created by Ashok on 3/17/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import os.log
import CoreData

class MainTableVC: UITableViewController , NSFetchedResultsControllerDelegate{
    
    @IBOutlet var myTableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = editButtonItem
        
        
        //generateTestData()
        attemptFetch()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections{
            return sections.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            print("returning number of rows\(sectionInfo.numberOfObjects)")

            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        
        // Configure the cell...
        let item = controller.object(at: indexPath)
        
        cell.itemTitle.text = item.title
        
        return cell
    }
    
    //selecting a particular row..
    
    /*
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     //  if
     let objs = controller.fetchedObjects
     
     let item = objs?[indexPath.row]
     print("able to select a row")
     print("item title:\(item?.title) item description:\(item?.descrip)")
     performSegue(withIdentifier: "DetailVC", sender: item)
     print("after performing segue")
     
     // }
     }*/
    /*
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     if let objs = controller.fetchedObjects, objs.count > 0 {
     
     let item = objs[indexPath.row]
     print("able to select a row")
     performSegue(withIdentifier: "DetailVC", sender: item)
     print("after performing segue")
     
     }
     }
     
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "DetailVC"{
     if let destination =  segue.destination as? DetailVC{
     
     if let item = sender as? Item{
     destination.itemToEdit = item
     print("inside tableview \(item.title) and \(item.descrip)")
     }
     else{
     print("unable to downcast the item")
     }
     }
     else{
     print("unable to find destination")
     }
     }
     else{
     print("unable to find the showitem segue")
     }
     }
     */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "AddNewItem":
            os_log("Adding a new item.", log: OSLog.default, type: .debug)
            
        case "DetailVC":
            guard let destination = segue.destination as? DetailVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedcell = sender as? Cell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedcell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            if let objs = controller.fetchedObjects, objs.count > 0 {
                
                let item = objs[indexPath.row]
                destination.itemToEdit = item
                
            }
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        
    }
    
    
    
    /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "ShowItem"{
     if let destination = segue.destination as? DetailVC{
     
     if let item = sender as? Item{
     destination.itemToEdit = item
     print("inside tableview \(item.title) and \(item.descrip)")
     }
     else{
     print("unable to downcast the item")
     }
     }
     else{
     print("unable to find destination")
     }
     }
     else{
     print("unable to find the showitem segue")
     }
     }*/
    
    func attemptFetch(){
        
        print("attempt fetch called")
        let fetchrequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        fetchrequest.sortDescriptors = [titleSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do{
            try controller.performFetch()
            
        } catch{
            
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myTableView.beginUpdates()
        print("begin updates")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("before end updates")
        myTableView.endUpdates()
        print("end updates")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type){
            
        case.insert:
            if let indexPath = newIndexPath{
                myTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath{
                print("inside switch case's delete")
                myTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath{
                let cell = myTableView.cellForRow(at: indexPath) as! Cell
                
                //configure cell
                
                let item = self.controller.object(at: indexPath)
                cell.itemTitle.text = item.title
                
            }
            break
        case.move:
            if let indexPath = indexPath{
                myTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                myTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
        
    }
    
    func generateTestData(){
        
        let item = Item(context: context)
        item.title = "data1"
        item.descrip = "description1"
        
        let item2 = Item(context: context)
        item2.title = "data2"
        item2.descrip = "description2"
        
        let item3 = Item(context: context)
        item3.title = "data3"
        item3.descrip = "description3"
        
        ad.saveContext()
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    /*
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            //myTableView.deleteRows(at: [indexPath], with: .fade)
            print("able to delete in table view")
            
            let item = controller.object(at: indexPath)
            
            
            context.delete(item)
            ad.saveContext()
            print("able to delete in DB")
           // myTableView.reloadData()
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
