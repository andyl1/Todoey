//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Andy Lee on 3/2/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    // MARK: - TABLE VIEW DELEGATE METHODS
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identify the cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        // Set SwipeTableViewCell delegate
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // handle action by updating model with deletion
            self.updateModel(indexPath: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-Icon")
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    func updateModel(indexPath: IndexPath) {
        
        // Update our data model.
    }
}
