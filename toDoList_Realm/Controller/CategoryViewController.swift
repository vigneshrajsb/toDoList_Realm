//
//  ViewController.swift
//  toDoList_Realm
//
//  Created by Vigneshraj Sekar Babu on 5/21/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {

    var array = ["1","2","3","4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDoList", sender: self)
    }

}

