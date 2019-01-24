//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andy Lee on 24/1/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - Table View Data Source Methods (Required)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identify the cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // For each cell, go to the corresponding index in categoryArray, and set the table view cell's textLabel to that category's name.
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    
    // MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Instantiate textfield object for pop up alert view.
        var textField = UITextField()
        
        // Instantiate alert pop up.
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // Instantiate action for pop up's button and what happens when it's pressed
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)       // This sends changes to the database to the context area.
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCatagories()
        }
        
        // Adds this specific action to this specific alert view pop up.
        alert.addAction(action)
        
        // Adds this specific textField to this specific alert view pop up.
        alert.addTextField { (alertViewTextField) in
            textField = alertViewTextField
            alertViewTextField.placeholder = "Create new category"
        }
        
        // Presents the pop up alert view on pressing the 'add' bar button item.
        present(alert, animated: true, completion: nil)
    }
    


    // MARK: - Data Manipulation Methods
    
    func saveCatagories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category context, \(error)")
        }
        
        // This line reloads the table view to show newly appended item in itemArray.
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from category context \(error)")
        }
        
        // This line reloads the table view to show newly appended item in itemArray.
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table View Delegate Methods
    
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    

    
    
    
    
}
