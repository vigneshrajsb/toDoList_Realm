//
//  ToDoListTableViewController.swift
//  toDoList_Realm
//
//  Created by Vigneshraj Sekar Babu on 5/21/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: UITableViewController {

    var selectedCategory : Category? {
        didSet{
            fetchData()
        }
    }
    
    
    
    var realm : Realm?
    
    var toDolist: Results<ToDoItems>?
    
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        realm = try! Realm()
        searchBar.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDolist?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
       
        cell.textLabel?.text = toDolist?[indexPath.row].item ?? "Nothing to show here"
        //remove the unwrapping below
        let flag = toDolist?[indexPath.row].completed ?? false
        cell.accessoryType = flag ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code
        if let item = toDolist?[indexPath.row] {
            do {
                try realm?.write() {
                    item.completed = !item.completed
                }
            } catch{
                print("Error updating data")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
 
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add", message: "Add item to do here", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textfield.text?.count ?? 0 > 0 {
                //save data
                let tempToDo = ToDoItems()
                tempToDo.item = textfield.text!
                tempToDo.completed = false
                tempToDo.dateCreated = Date.init(timeIntervalSinceNow: Double(self.secondsFromGMT))
                
                self.saveData(toDo: tempToDo)
            }
        }
        alert.addAction(action)
        alert.addTextField { (textbox) in
            textfield = textbox
        }
        present(alert, animated:  true)
    }
    
    func saveData(toDo : ToDoItems) {
        do {
            try realm?.write {
                selectedCategory?.toDos.append(toDo)
                realm?.add(toDo)
            }
        } catch {
            print("Error while saving toDo item to realm : \(error)")
        }
        tableView.reloadData()
    }
    
    func fetchData() {
        //toDolist = realm.objects(ToDoItems.self)
        navigationItem.title = selectedCategory?.categoryName
        toDolist = selectedCategory?.toDos.sorted(byKeyPath: "completed")
        tableView.reloadData()
    }
    
    @IBAction func detailPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    
}

//MARK: - search methods
extension ToDoListTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button clicked")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //code
        print("search text did change")
    }
    
}
