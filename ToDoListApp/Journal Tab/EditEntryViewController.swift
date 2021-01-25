//
//  EditEntryViewController.swift
//  ToDoListApp
//
//  Created by T.J on 15/01/2021.
//  Copyright © 2021 TETRA. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController, UITextViewDelegate {

    //MARK:- Lifecycle

    //MARK:When the vie first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.keyboardDismissMode = .onDrag
        
        //enable scroll
        textView.isScrollEnabled = true
        textView.scrollRangeToVisible(NSRange())
        
        //make date shows the date of selected entry
        if let entryDate = selectedEntry!.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            self.title = formatter.string(from: entryDate)
        }
        
        //make texView show the text of selected entry
        textView.text = selectedEntry?.text

    }

    //MARK:Every time the view appears
    override func viewWillAppear(_ animated: Bool) {
        
        //make texView show the text of selected entry
        textView.text = selectedEntry?.text
    }
    
    //MARK:- IBOutlets and Variable decarations
    @IBOutlet weak var textView: UITextView!
    
    //declare variable to hold selected entry data passed from home journal vc
    var selectedEntry:Entry?
    
    
    //MARK:- IBActions and Functions
    @IBAction func doneTapped(_ sender: Any) {
        
        //get refference to app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //update entry item with new changes made by user
        selectedEntry?.title = textView.text
        selectedEntry?.text = textView.text
        selectedEntry?.date = Date(timeIntervalSinceNow: 0)
        
        do {
            //save updated entry
            appDelegate.saveContext()
            
        } catch {
            //failed updated to save entry
            print("failed to save changes made to entry")
            
        }
        
        //Go back by one view controller
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:- Text Field delegate methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.endEditing(true)
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
