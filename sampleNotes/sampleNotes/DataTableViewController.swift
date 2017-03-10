//
//  DataTableViewController.swift
//  sampleNotes
//
//  Created by Ashok on 2/28/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import os.log

class DataTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var items = [DataModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load the sample data.
        loadSampleMeals()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ViewController, let data = sourceViewController.data {
            
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing notes.
                
                items[selectedIndexPath.row] = data
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // Add a new notes.
                let newIndexPath = IndexPath(row: items.count, section: 0)
                items.append(data)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DataTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DataTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DataTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let data = items[indexPath.row]
        
        cell.title.text = data.title
        
        return cell
    }
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     
        // Delete the row from the data source
        items.remove(at: indexPath.row)

     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
    
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new notes.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let ViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? DataTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selected = items[indexPath.row]
            ViewController.data = selected
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleMeals() {
        
        guard let data1 = DataModel(title: "First Data", info: "inside Data1")
            else{
                fatalError("Unable to instantiate Data1")
        }
        
        guard let data2 = DataModel(title: "Second Data", info: "inside Data2")
            else{
                fatalError("Unable to instantiate Data1")
        }
        guard let data3 = DataModel(title: "Third Data", info: "inside Data3")
            else{
                fatalError("Unable to instantiate Data1")
        }
        
        items += [data1, data2, data3]
        
        
    }
    
}
