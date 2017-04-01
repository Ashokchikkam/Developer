import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myTableView: UITableView  =   UITableView()
    var itemsToLoad: [String] = ["One", "Two", "Three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        myTableView.frame =
            CGRectMake(0, 0, screenWidth, screenHeight);
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        self.view.addSubview(myTableView)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemsToLoad.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.itemsToLoad[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("User selected table row \(indexPath.row) and item \(itemsToLoad[indexPath.row])")
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let shareAction  = UITableViewRowAction(style: .Normal, title: "Share") { (rowAction, indexPath) in
            print("Share Button tapped. Row item value = \(self.itemsToLoad[indexPath.row])")
            
            self.displayShareSheet(indexPath)
        }
        let deleteAction  = UITableViewRowAction(style: .Default, title: "Delete") { (rowAction, indexPath) in
            print("Delete Button tapped. Row item value = \(self.itemsToLoad[indexPath.row])")
        }
        shareAction.backgroundColor = UIColor.greenColor()
        return [shareAction,deleteAction]
    }
    
    func displayShareSheet(indexPath: NSIndexPath)
    {
        let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .ActionSheet)
        
        let shareViaFacebook = UIAlertAction(title: "Share via Facebook", style: .Default, handler: { (action) -> Void in
            print("Send now button tapped for value \(self.itemsToLoad[indexPath.row])")
        })
        
        let shareViaEmail = UIAlertAction(title: "Share via Email", style: .Default, handler: { (action) -> Void in
            print("Delete button tapped for value \(self.itemsToLoad[indexPath.row])")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
            self.myTableView.setEditing(false, animated: true)
        })
        
        alertController.addAction(shareViaFacebook)
        alertController.addAction(shareViaEmail)
        alertController.addAction(cancelButton)
        
        self.navigationController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
