//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andy Lee on 24/1/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    
    // MARK: - TABLE VIEW DATA SOURCE METHODS (REQUIRED)
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identify the cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // For each cell, go to the corresponding index in categoryArray, and set the table view cell's textLabel to that category's name.
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categoies Added"
        
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
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
    
    
    // MARK: - TABLE VIEW DELEGATE METHODS
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // To stop cell from staying grey after selecting a cell.
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
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
