//
//  ViewController.swift
//  Todoey
//
//  Created by Andy Lee on 20/1/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    // Initialise new Realm database access point.
    let realm = try! Realm()
    
    // Initialise new array of type Results to store Item objects.
    var toDoItems : Results<Item>?
    
    // Initialise a new variable for prepareForSegue to pass over the Category name selected.
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
    }
    
    

    //MARK: - TABLE VIEW DATA SOURCE METHODS (REQUIRED)
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    
    //MARK: - TABLE VIEW DELEGATE METHODS
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Toggle done/not done status and update Realm.
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error in saving done status, \(error)")
            }
        }
        
        // To stop cell staying grey after selecting a cell.
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - ADD NEW ITEMS
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
                
        var textField = UITextField()
        
        // Instantiate alert view.
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // Instantiate alert action.
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Updates the 'items' property of Category model when 'Add Item' is pressed.
            // Adds an Item object to the Category List/Array.
            // Do not need to use .save method as we are not creating a new object, just appending to existing Category.
            if let currentCategory = self.selectedCategory {
                print(currentCategory)
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)   // Does this need .save, just append.
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    
    //MARK: - MODEL MANIPULATION METHODS
    
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    override func updateModel(indexPath: IndexPath) {
        
        if let itemForDeletion = toDoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}



// MARK: - SEARCH BAR METHODS


extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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
