//
//  ToDoListTableViewController.swift
//  toDoList_Realm
//
//  Created by Vigneshraj Sekar Babu on 5/21/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    var toDoArray = ["5","3","2","1"]
    
    override func viewDidLoad() { 
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        return cell
    }
    
}
