//
//  HabitTrackerTableViewController.swift
//  ToDoListApp
//
//  Created by T.J on 25/01/2021.
//  Copyright © 2021 TETRA. All rights reserved.
//

import UIKit
import CoreData

class HabitTrackerTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        fetchHabits()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchHabits()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    var habit:[Habit] = []
    
    var currentHabit:Habit?
    
    func fetchHabits() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = Habit.fetchRequest() as NSFetchRequest<Habit>
        
        do {
            habit = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            print("Successfully retrieved Habits from Core Data")
            
        } catch {
            
            print("Unsuccessful in retrieving Habits from Core Data")
            
        }
        
        
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard habit.count > 0 else {
            
            return 0
        
        }
        
        return habit.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitTrackerTableViewCell
        let currentHabit = habit[indexPath.row]

        // Configure the cell...
        cell.habitTitle.text = habit[indexPath.row].title!
        
        
        cell.outOf100.text = "\(currentHabit.progress)/\(currentHabit.goal)"
        cell.backgroundImage.backgroundColor = .link
        cell.progressMeter.progress = Float(habit[indexPath.row].progress) / Float(habit[indexPath.row].goal)
        
        if currentHabit.progress == currentHabit.goal {
            
            cell.completionImage.alpha = 1
            
        } else if currentHabit.progress != currentHabit.goal {
            
            cell.completionImage.alpha = 0
            
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! HabitTrackerTableViewCell
        
        let selectedHabit = habit[indexPath.row]
        
        currentHabit = selectedHabit
        
        let actionSheet = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "+1", style: .default, handler: { (action) in
            
            if selectedHabit.progress < selectedHabit.goal {
            
            selectedHabit.progress += 1
            selectedCell.outOf100.text = "\(selectedHabit.progress)/\(selectedHabit.goal)"
            selectedCell.progressMeter.progress = Float(selectedHabit.progress) / Float(selectedHabit.goal)
                
                if selectedHabit.progress == selectedHabit.goal {
                    
                    UIView.animate(withDuration: 1.0) {
                        selectedCell.completionImage.alpha = 1
                    }
                    
                    let completedHabitAlert = UIAlertController(title: "Congradulations!", message: "You have reached your goal!", preferredStyle: .alert)
                    completedHabitAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(completedHabitAlert, animated: true)
    
                }
            
            } else if selectedHabit.progress == selectedHabit.goal {
                
                let alreadyAtMaxAlert = UIAlertController(title: "Congradulations!", message: "you already reached max counts for this habit", preferredStyle: .alert)
                alreadyAtMaxAlert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                self.present(alreadyAtMaxAlert, animated: true)
                
            }
            
            appDelegate.saveContext()
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "-1", style: .default, handler: { (action) in
            
            if selectedHabit.progress > 0 {
                
                selectedHabit.progress -= 1
                selectedCell.outOf100.text = "\(selectedHabit.progress)/\(selectedHabit.goal)"
                selectedCell.progressMeter.progress = Float(selectedHabit.progress) / Float(selectedHabit.goal)
                
                if selectedHabit.progress < selectedHabit.goal {
                    
                    UIView.animate(withDuration: 1.0) {
                        selectedCell.completionImage.alpha = 0
                    }
                    
                }
                
                
                
            } else if selectedHabit.progress <= 0 {
                
                let alreadyAtZeroAlert = UIAlertController(title: "Oops", message: "you already have zero counts forthis habit", preferredStyle: .alert)
                alreadyAtZeroAlert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                self.present(alreadyAtZeroAlert, animated: true)
                
            }
            
            appDelegate.saveContext()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            
            self.performSegue(withIdentifier: "showEditHabit", sender: Any?.self)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
                   
               }))
        
        present(actionSheet, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteSwipeAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            
            let selectedHabit = self.habit[indexPath.row]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(selectedHabit)
            
            appDelegate.saveContext()
            
            self.fetchHabits()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        deleteSwipeAction.backgroundColor = .red
        deleteSwipeAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteSwipeAction])
        
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

    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showEditHabit" {
            
            let editHabtTableViewController = segue.destination as! EditHabitTableViewController
            
            editHabtTableViewController.selectedHabit = currentHabit
            
        }
    }


}
