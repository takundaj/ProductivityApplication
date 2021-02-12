//
//  JournalHomeTableViewController.swift
//  ToDoListApp
//
//  Created by T.J on 14/01/2021.
//  Copyright © 2021 TETRA. All rights reserved.
//
import CoreData
import UIKit

class JournalHomeTableViewController: UITableViewController {

    //MARK:- Lifecycle methods
    
    //MARK:When This View Controller First Loads/Appear
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:Every Time This View Aontroller Appears
    override func viewWillAppear(_ animated: Bool) {
        
        //Fetch journal entries from managed context (core data)every time view appears
        fetchEntries()
        
        //Reload table view every time view appears
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Varible declarations
    
       var entries:[Entry] = []
       
       var selectedEntry: Entry?
    
    //get reference to App Delegate and Context
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK:- Function declarations
    
    //declare fetch method
    func fetchEntries() {
        
        //get reference to managed context (Core Data)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //get refference to fetch request
        let request = Entry.fetchRequest() as NSFetchRequest<Entry>
        
        //ceate sort prefferneces
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        //apply sort prefferences to request
        request.sortDescriptors = [sortDescriptor]
        
        do {
            //Attempt fetch
            entries = try context.fetch(request)
            
            // reload tableVIew to show fetched items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            print("Successfully retrieved Journal Entries from Core Data")
        
        } catch {
        
            print("Falied to retrieve Journal Entries from Core Data")
        
        }
        
        
    }

    // MARK: - TableView DataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return the number of rows
        return entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get referrence to current entry data
        let currentEntry = entries[indexPath.row]
        
        //Get refference to current table view cell (which will display the current entry data)
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalentrycell", for: indexPath) as! JournalHomeTableViewCell
        
        //get a reference to the first line of the entry
        let firstline = currentEntry.title?.components(separatedBy: ".").first
        
        //Configure cell...
        
        //assign entry text to label
        cell.entrySnippet.text = currentEntry.text
        
        //Set date format
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        
        //get a refferece to formated date
        let date = currentEntry.date
        
        //if date has a value assign it to label
        if date != nil {
                
            //configure date label in cell
            cell.titleLabel.text = formatter.string(from: date!)
        }
        
        //return configured cell to display
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //get reference to selected entry
        selectedEntry = entries[indexPath.row]
        
        //present Edit Journal View Controller
        performSegue(withIdentifier: "showEditJournal", sender: Any?.self)
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            
            var entryToDelete = self.entries[indexPath.row]
            
            self.context.delete(entryToDelete)
            
            self.appDelegate.saveContext()
            
            self.fetchEntries()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
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

    
    // MARK: - Navigation + Segues

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        //If this is the Edit Journal Segues
        if segue.identifier == "showEditJournal" {
            
            // Get the new view controller using segue.destination.
            let JournalEditVC = segue.destination as! EditEntryViewController
            
            // Pass the selected object to the new view controller.
            JournalEditVC.selectedEntry = selectedEntry
        }
    }
    
    
    
    
    
}
