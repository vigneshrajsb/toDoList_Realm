//
//  SwipeTableViewController.swift
//  toDoList_Realm
//
//  Created by Vigneshraj Sekar Babu on 5/28/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.delete(at: indexPath)
        }
        
        /*
         ----added the below code to the ToDoListController as i only needed the complete action in Items and not in categories.
         ??--heck if it is a good practice to import SwipcCellKit again in ToDOList controller
         
         let updateAction = SwipeAction(style: .default, title: "Complete") { (action, indexPath) in
            self.update(at: indexPath)
        }
        return [deleteAction, updateAction] */
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func delete(at indexPath : IndexPath) {
        //some super code
    }
    
    func update(at indexPath : IndexPath){
        //some super code here
    }
    

}
