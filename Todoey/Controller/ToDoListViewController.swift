//
//  ViewController.swift
//  Todoey
//
//  Created by Andy Lee on 20/1/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))

    }
    
    

    //MARK: - Table View Datasource Methods (required)
    
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
    
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Toggling the item cell's 'done' property on selecting a cell.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Call saveItem to encode change made to 'done' property
        saveItems()
        
        // To stop cell from staying grey after selecting a cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // UIAlertView setup
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // UIAlertAction setup
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // What will happen when the user clicks the 'Add Item' button
            
            // Create new item and set it's title from the text in textField
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
    

    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        // This line reloads the table view to show newly appended item in itemArray.
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)
        request.predicate = predicate
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        // This line reloads the table view to show newly appended item in itemArray.
        self.tableView.reloadData()
    }
}



// MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
