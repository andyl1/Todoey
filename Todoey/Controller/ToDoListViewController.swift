//
//  ViewController.swift
//  Todoey
//
//  Created by Andy Lee on 20/1/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Complete Todoey"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Build website"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Buy eggs"
        itemArray.append(newItem3)

        // This condition ensures there is a plist of persisted items with the key "ToDoListArray" before loading itemsArray on screen
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    
    
    //MARK - Create Table View Datasource Methods (required)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Prevent cell reuse from retaining the cell's previous accessoryType by matching to the property's 'done' value.
        cell.accessoryType = (item.done) ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    //MARK - Create Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Toggling the item cell's 'done' property on selecting a cell.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // To stop cell from staying grey after selecting a cell.
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Reloads all table view data after selecting a cell.
        tableView.reloadData()
        
    }
    
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // UIAlertView setup
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // UIAlertAction setup
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when the user clicks the Add Item button
            
            // Create new item and set it's title from the text in textField
            let newItem = Item()
            newItem.title = textField.text!
            
            // Append the new item to the itemArray, and save to UserDefaults plist.
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            // This line reloads the table view to show newly appended item in itemArray.
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    
    
}

