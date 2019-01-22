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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newItem = Item()
//        newItem.title = "Complete Todoey"
//        itemArray.append(newItem)
//        
//        let newItem2 = Item()
//        newItem2.title = "Build website"
//        itemArray.append(newItem2)
//        
//        let newItem3 = Item()
//        newItem3.title = "Buy eggs"
//        itemArray.append(newItem3)

        // Call loadItems function to decode items saved to plist and display in table view.
        loadItems()
        
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
        
        // Call saveItem to encode change made to 'done' property
        saveItems()
        
        // To stop cell from staying grey after selecting a cell.
        tableView.deselectRow(at: indexPath, animated: true)
        
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
            
            // Call saveItem to encode the new item entered for 'title' property.
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        // Encode itemsArray after entering a new item or changing done property.
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding itemArray, \(error)")
        }
        
        // This line reloads the table view to show newly appended item in itemArray.
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding itemArray, \(error)")
            }
        }
        
    }
    
}

