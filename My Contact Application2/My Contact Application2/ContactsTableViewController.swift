//
//  ContactsTableViewController.swift
//  My Contact Application2
//
//  Created by Harry Dulaney on 11/12/19.
//  Copyright © 2019 Ethical Techniques. All rights reserved.
//
import CoreData
import UIKit

class ContactsTableViewController: UITableViewController {
    
    //let contacts = ["Jim", "John", "Dana", "Rosie", "Justin", "Jeremy", "Sarah", "Matt", "Joe", "Donald", "Jeff"]
       var contacts:[NSManagedObject] = []
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
   
    }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
              // Pass the selected object to the new view controller.
                      if segue.identifier == "EditContact" {
                        let contactController = segue.destination as? ContactViewController
                          let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
                          let selectedContact = contacts[selectedRow!] as? Contact
                          contactController?.currentContact = selectedContact!
                      }
                    }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    override func viewWillAppear(_ animated: Bool) {
          loadDataFromDatabase()
          tableView.reloadData()
      }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    func loadDataFromDatabase(){
        //Set up Core Data Context
        let context = appDelegate.persistentContainer.viewContext
        //Set up Request
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        
        //Execute request
        do {
            contacts = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath)

        // Configure the cell...
        let contact = contacts[indexPath.row] as? Contact
        cell.textLabel?.text = contact?.contactName
        cell.detailTextLabel?.text = contact?.city
        cell.accessoryType = .detailDisclosureButton
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
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

    
    // MARK: - Navigation



}