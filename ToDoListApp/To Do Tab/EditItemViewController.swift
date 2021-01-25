//
//  EditItemViewController.swift
//  ToDoListApp
//
//  Created by T.J on 13/12/2020.
//  Copyright © 2020 TETRA. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController, UITextFieldDelegate {
   
    
    //MARK:- IBOUTLET connections + variable declarations
    
    @IBOutlet var titleField:UITextField!
    @IBOutlet var bodyField:UITextField!
    @IBOutlet var date:UIDatePicker!
    
    //create reference to item we want to edi
    var selectedItem:Item!
    
    
    
    //MARK:- Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Edit To Do Item"
        
        //set this view controller as the title and body textfield's delegate
        titleField.delegate = self
        bodyField.delegate = self
        
        //set textfields text to the current title & body of selected item
        titleField.text = selectedItem.title
        bodyField.text = selectedItem.notes
        date.setDate(selectedItem.date!, animated: true)
        
    }
    
    
    //MARK:- Text Field delegate methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK:- IBAction methods
    
    //When user taps save button
    @IBAction func didTapSave() {
        
        //Check is title field is not empty.
        if titleField.text?.isEmpty == false {
            
            //get context
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            //delete the 'to be replaced' object from core data
            context.delete(selectedItem)
            
            //create new 'replacement' object
            let newItem = Item(context: context)
            
            //assign new changes to replacement To Do Item
            newItem.title = titleField.text
            newItem.notes = bodyField.text
            newItem.date = date.date
            
            //save 'replacement' object to core data
            appDelegate.saveContext()
            
            
            DispatchQueue.main.async {
                
                //notification declaration
                let content = UNMutableNotificationContent()
                
                //configure notification (title, sound & body text)
                content.title = self.titleField.text!
                content.sound = .default
                content.body = self.bodyField.text!
                
                //prepare inputs for notifications request
                let targeData = self.date.date
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targeData), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content , trigger: trigger)
                
                //Notification request/call
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    
                    //notofication request is unsuccessful print error to console
                    if error != nil {
                        print("Notifcation error")
                        
                    }
                    
                })///End of userNotificationCentre completion handler
                
            }///End of dispatchques
            
            //return to / present home view controller after save is complete
            navigationController?.popViewController(animated: true)
            
        } else {
            
            //if title field is empty - creaate & preesen alert
            let emptyFieldAlert = UIAlertController(title: "Empty Fields", message: "Please fill in all fields to save item", preferredStyle: .alert)
            
            //add "OK" dismisal action to alert
            emptyFieldAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            
            //present alert
            present(emptyFieldAlert, animated: true)
            
        } ///end of if statement
        
    }///end of didTapSave
    

    
}

