//
//  NewEntryViewController.swift
//  ToDoListApp
//
//  Created by T.J on 15/01/2021.
//  Copyright © 2021 TETRA. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController, UITextViewDelegate {
    
    //MARK:- Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.keyboardDismissMode = .onDrag
        
        //enable scroll
        textView.isScrollEnabled = true
        textView.scrollRangeToVisible(NSRange())    }
    
    //MARK:- IBOulets and Vaiable Declarations
    
    @IBOutlet weak var textView: UITextView!
    
    //MARK:- IBAction methods and Functions

    //MARK: Save button
    @IBAction func saveTapped(_ sender: Any) {
        
        //get referrence to managd obhect context (Core Data)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //create new Entry object
        var newEntry = Entry(context: context)
        
        //configue object with user inputs
        newEntry.title = textView.text
        newEntry.text = textView.text
        newEntry.date = Date(timeIntervalSinceNow: 0)
        
        
        do {
            //save new Entry object to core data
            appDelegate.saveContext()
            
        } catch {
            //failed to save new Entry object
            print("Failed to save new entry")
        
        }
        
        //When complete, go back by one view controller
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Text View Delegate protocol

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
