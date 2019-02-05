//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andy Lee on 24/1/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // Initialise new Realm database access point.
    let realm = try! Realm()
    
    // Initialise new array of type Results to store Category objects.
    var categoryArray : Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    
    
    // MARK: - TABLE VIEW DATA SOURCE METHODS (REQUIRED)
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Tap into superclass
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            
            // For each cell, go to the corresponding index in categoryArray, and set the table view cell's textLabel to that category's name.
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colourHex) else { fatalError() }
            
            // Set cell background colour.
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell
    }
    
    
    
    // MARK: - ADD NEW CATEGORIES
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // Instantiate alert view.
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // Instantiate alert action.
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Creates a new category on pressing 'Add' button.
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colourHex = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        // Adds this specific action to this specific alert view.
        alert.addAction(action)
        
        // Adds this specific textField to this specific alert view.
        alert.addTextField { (alertViewTextField) in
            textField = alertViewTextField
            alertViewTextField.placeholder = "Create new category"
        }
        
        // Presents the alert view on pressing the 'add' bar button item.
        present(alert, animated: true, completion: nil)
    }
    


    // MARK: - DATA MANIPULATION METHODS
    
    
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category context, \(error)")
        }
        
        // This line reloads the table view to show newly appended item in itemArray.
        tableView.reloadData()
    }
    
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    override func updateModel(indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    
    
    // MARK: - TABLE VIEW DELEGATE METHODS
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        // To stop cell from staying grey after selecting a cell.
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        // Creates a constant of type destination view controller.
        let destinationVC = segue.destination as! ToDoListViewController
        
        // Passing our categoryArray's indexPath.row to the destination view controller's "selectedCategory" property.
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}
