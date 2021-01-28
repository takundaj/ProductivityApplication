//
//  NewItemTableViewController.swift
//  ToDoListApp
//
//  Created by T.J on 27/01/2021.
//  Copyright © 2021 TETRA. All rights reserved.
//

import UIKit

class NewItemTableViewController: UITableViewController, UITextFieldDelegate {

    //MARK:- IBOutlet declarations
    
    @IBOutlet var titleField:UITextField!
    @IBOutlet var bodyField:UITextField!
    @IBOutlet var date:UIDatePicker!
 
    //MARK:- Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.delegate = self
        bodyField.delegate = self

        // Do any additional setup after loading the view.
    }
   
    
    
    //MARK:- Text Field delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
 
    //MARK:- IBAction methods
    
    @IBAction func didTapSave() {
        
        if titleField.text?.isEmpty == false {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newItem = Item(context: context)
            
            newItem.title = titleField.text
            newItem.notes = bodyField.text
            newItem.date = date.date
            
            appDelegate.saveContext()
        
        //notification declaration and request/call
        DispatchQueue.main.async {
                        let content = UNMutableNotificationContent()
            content.title = self.titleField.text!
                    content.sound = .default
            content.body = self.bodyField.text!
                    
            let targeData = self.date.date
                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targeData), repeats: false)
                
            let request = UNNotificationRequest(identifier: "some_long_id", content: content , trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                
                if error != nil {
                    print("Notifcation error")
                
                }
                
            })///End of userNotificationCentre
            
        }///End of dispatchques
        
        // return to/present home view controller after save is complete
        navigationController?.popViewController(animated: true)
        
        } else {
            
            let emptyFieldAlert = UIAlertController(title: "Empty Fields", message: "Please fill in all fields to save item", preferredStyle: .alert)
            
            emptyFieldAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            
            present(emptyFieldAlert, animated: true)
            
        }
            
        }///end of didTapSave
    

}
