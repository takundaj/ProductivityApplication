//
//  HomeTableViewController.swift
//  ToDoListApp
//
//  Created by T.J on 08/12/2020.
//  Copyright © 2020 TETRA. All rights reserved.
//

import CoreData

import UIKit

class HomeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //Declare variable to hold To DO itms retrieved from core data
    var items:[Item]!
    
    //get reference to App Delegate and Context
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK:- Lifecycle methods
    
    //MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetch To Do items form core data (will be stored in items array)
        fetchItems()
        
        //notifiction permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(success, error) in
            
            if success {
                //Check if notification permission was given
                print("user has given app permisson to show notifications")
               
            } else if let error = error {
                //Check if notification permission was given
                print("error occured at notification permision")
                
            }
            
        })
        
    }
    
    //MARK: view will appear
    override func viewWillAppear(_ animated: Bool) {
        
        //each time view appears refetch items and reload table view
        fetchItems()
        
    }
    
    
    //MARK:- Varibale declarations
    
    var currentItem:Item?
    
    
    //MARK:- Functions declarations
    
    func fetchItems() {
        
        //get refference to core data item fetch request
        let request = Item.fetchRequest() as NSFetchRequest<Item>
        
        //organise items that will be fetched in date order (earlier date first)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        //add 'sort by date' configuration, created above, to your request
        request.sortDescriptors = [sortDescriptor]
        
        //try fetch To Do items from core data
        do {
            
            items = try context.fetch(request)
            
        } catch {
            
        }
        
        //reload table view
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Table View Datasource and Deleagte protocol
    
    //MARK: Number of sections in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //return one section in table view
        return 1
        
    }
    
    //MARK: Number of rows in each section of the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return number of To Do Items
        return items.count
        
    }
    
    //MARK: What data should be displayed at each cell/row of table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemcell", for: indexPath) as! HomeTableViewCell
        
        //Configure the cell...
        cell.itemTitle.text = items[indexPath.row].title
        cell.itemNotes.text = items[indexPath.row].notes
        
        //get refference to date of each to do item
        let date = items[indexPath.row].date
        
        //Set what format for to do list date to be displayed as
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        
        //Check if item has a date
        if date != nil {
            
            //configure date label in cell
            cell.dateLabel?.text = formatter.string(from: date!)
            
        }
        
        //get refference to to do item currently being shown
        let currentObject = self.items[indexPath.row]
        
        //if current ibject it "done"
        if currentObject.isDone == true {
            
            //Set cell background to light green
            cell.backgroundColor = UIColor(red: 0.5922, green: 1, blue: 0.5294, alpha: 1.0)
            cell.accessoryType = .checkmark
            
        //if currrent object is NOT "done"
        } else if currentObject.isDone == false {
            
            //Set cell background colur to white
            cell.backgroundColor = .white
            
        }
        
        //return configured cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //MARK: Get referrence to the actions sheet
        let actionSheet = UIAlertController(title: "", message: "which action would you like to choose?", preferredStyle: .actionSheet)
        
        //Function that wil return the doneAction button title. This will be entered in the title parameter for the action.
        func doneActionTitle() -> String {
            
            //get referrence to item
            let item = items[indexPath.row]
            
            //If selected item is NOT done, show "done"
            if item.isDone == false {
                
                return "Done"
            
            //If selected item is done, show "undo"
            } else if item.isDone == true {
                
                return "Undo"
                
            } else {
                
                return "Undo"
            }
        }
        
        //MARK: Done Action
        let doneAction = UIAlertAction(title: doneActionTitle(), style: .default) { (alert:UIAlertAction!) in
            
            //get reference to cell at current index path
            let cell = tableView.cellForRow(at: indexPath)
            
            //get reference to item data at current index path
            let currentObject = self.items[indexPath.row]
            
            //if current to do item is not "done" and action is pressed
            if currentObject.isDone == false {
                
                //set current to do item as "done"
                currentObject.isDone = true
                
                //change cells colour to GREEN and ADD checkmark accessory view
                UIView.animate(withDuration: 1.5, animations: {
                    cell?.accessoryType = .checkmark
                    cell?.backgroundColor = UIColor(red: 0.5922, green: 1, blue: 0.5294, alpha: 1.0)
                    
                })
                
                //save todo item as "done"
                self.appDelegate.saveContext()
                
              //However, if current to do item is not "done" and action is pressed
            } else if currentObject.isDone == true {
                
                //set current to do item as NOT "done"
                currentObject.isDone = false
                
                //change cells colour to WHITE and and REMOVE checkmark accessory view
                cell?.accessoryType = .none
                cell?.backgroundColor = .white
            }
            
        }
        
        //MARK: Edit Item Action
        let editAction = UIAlertAction(title: "Edit", style: .default) { (alert:UIAlertAction!) in
            
            //get refference to selected To Do Item
            self.currentItem = self.items[indexPath.row]
            
            self.performSegue(withIdentifier: "showEditTodo", sender: Any.self)
            

        }
        
        //MARK: Delete Item Action
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (alert:UIAlertAction!) in
            //set item to remove
            let itemToRemove = self.items![indexPath.row]
            
            //remove from data base
            self.context.delete(itemToRemove)
            
            //re-save database data
            self.appDelegate.saveContext()
            
            //re-fetch
            self.fetchItems()
            
            //relod table view
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        }
        
        //MARK:Cancel acion sheet buton
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //MARK: Adding actions to action sheet controller
        actionSheet.addAction(doneAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancel)
        
        //MARK: Present action sheet 
        present(actionSheet, animated: true)
        
    }
    

    
    //MARK:- Trailing Swipe actions
    
    //MARK:Delete To Do Item
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            
            //set item to remove
            let itemToRemove = self.items![indexPath.row]
            
            //remove from data base
            self.context.delete(itemToRemove)
            
            //re-save database data
            self.appDelegate.saveContext()
            
            //re-fetch
            self.fetchItems()
            
            //relod table view
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
            //re-fetch update database data + assign to items array
            completionHandler(true)
        }
        
        //configure delete swipe option image
        deleteAction.image = UIImage(systemName: "trash")
        
        //add newly declared delete action funtionality to the table view
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        //return updated swipe configuration
        return swipeConfiguration
    }
    
    
    
    //MARK:- Leading swipe action
    
    //MARK: Edit To Do Item
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //declare new edit action
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (action, view, completionHandler) in
            
            self.currentItem = self.items[indexPath.row]
            
            self.performSegue(withIdentifier: "showEditTodo", sender: Any?.self)
            
        }
        
        //configure edit swipe option image
        editAction.image = UIImage(systemName: "pencil")
        
        //add newly declared edit action funtionality to the table view
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [editAction])
        
        //return updated swipe configuration
        return swipeConfiguration
        
    }
    
    
    
    //MARK:- Unwind to HomeViewController segue
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Edit controller segue preperation
        if segue.identifier == "showEditTodo" {
            let editViewController = segue.destination as! EditItemViewController
            editViewController.selectedItem = currentItem
        }
        
    }
    
    
}
