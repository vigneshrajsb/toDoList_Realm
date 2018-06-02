//
//  ToDoListTableViewController.swift
//  toDoList_Realm
//
//  Created by Vigneshraj Sekar Babu on 5/21/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import  ChameleonFramework

class ToDoListTableViewController: SwipeTableViewController {
    
    var selectedCategory : Category? {
        didSet{
            fetchData()
        }
    }
    
    var showAll : Bool = false
    var realm : Realm?
    var toDolist: Results<ToDoItems>?
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        realm = try! Realm()
        searchBar.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //code
        guard let colorCode = selectedCategory?.categoryColor else {
            fatalError("category color doesnt exist")
        }
        updateNavBar(withHexCode: colorCode)
  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "27C2F8")
    }
    
    func updateNavBar(withHexCode colorHexCode : String){

        guard let navBar = navigationController?.navigationBar else { fatalError("nav bar doesnt exist")}
        guard let color = UIColor(hexString: colorHexCode) else {
            fatalError("cannot convert hex to UIColor")
        }
        navBar.barTintColor = color
        navBar.tintColor = ContrastColorOf(color, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(color, returnFlat: true)]
        searchBar.barTintColor = color
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDolist?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = toDolist?[indexPath.row].item ?? "Nothing to show here"
        //remove the unwrapping below
        let flag = toDolist?[indexPath.row].completed ?? false
        cell.accessoryType = flag ? .checkmark : .none
    
        if let color = UIColor(hexString: (selectedCategory?.categoryColor)!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDolist?.count ?? 1))
        {
        cell.backgroundColor = color
            cell.textLabel?.textColor =  ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    fileprivate func update(_ indexPath: IndexPath, _ tableView: UITableView) {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //update(indexPath, tableView)
        //no updates needed when row is selected
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
 
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add", message: "Add item to do here", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //should use the selected categiry to check for null values here, i used text like a beginner
            if textfield.text?.count ?? 0 > 0 {
                //save data
                let tempToDo = ToDoItems()
                tempToDo.item = textfield.text!
                tempToDo.completed = false
                tempToDo.dateCreated = Date.init(timeIntervalSinceNow: 0)
                //tempToDo.itemColor = UIColor.randomFlat.hexValue()
                
                self.saveData(toDo: tempToDo)
            }
        }
        alert.addAction(action)
        alert.addTextField { (textbox) in
            textfield = textbox
        }
        present(alert, animated:  true)
    }
    
    @IBAction func showAllPressed(_ sender: UIBarButtonItem) {
        showAll = !showAll
        if showAll {sender.title = "Pending"} else {sender.title = "Show All"}
        fetchData()
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
        if showAll {
        toDolist = selectedCategory?.toDos.sorted(byKeyPath: "dateCreated").sorted(byKeyPath: "completed")
        } else {
            toDolist = selectedCategory?.toDos.filter("completed == false").sorted(byKeyPath: "dateCreated")
        }
        tableView.reloadData()
    }
    
    override func delete(at indexPath: IndexPath) {
        if let selectedItem = toDolist?[indexPath.row] {
        do {
            try realm?.write {
                realm?.delete(selectedItem)
            }
        } catch { print("error while deleting todo item \(error)")}
    }
    }
    
    override func update(at indexPath: IndexPath) {
        if let selectedItem = toDolist?[indexPath.row] {
            do{
                try realm?.write {
                    selectedItem.completed = !selectedItem.completed
                    tableView.reloadData()
                }
            } catch {
                print("error while updating To Do iten \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
         guard orientation == .right else { return nil }
        var Action  = super.tableView(tableView, editActionsForRowAt: indexPath, for: .right)
        let updateAction = SwipeAction(style: .default, title: buttonTitle(at: indexPath)) { (action, indexPath) in
            self.update(at: indexPath)
        }
        Action?.append(updateAction)
        return Action
    }
    
    func buttonTitle(at indexPath : IndexPath) -> String {
        var title = ""
        if let status = toDolist?[indexPath.row].completed {
            if status { title = "Toggle"} else { title = "Complete"}
        }
         return title
    }

    
}
    
//MARK: - search methods
extension ToDoListTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        toDolist = toDolist?.filter("item CONTAINS[cd] %@", searchBar.text)
        //        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //code
        if searchBar.text?.count == 0 {
            fetchData()
        } else {
             var query = ""
            if showAll {query = "item CONTAINS[cd] %@"} else {query = "item CONTAINS[cd] %@  AND completed == false"}
            
            toDolist = selectedCategory?.toDos.filter(query, searchBar.text ?? "").sorted(byKeyPath: "dateCreated").sorted(byKeyPath: "completed")
            if !showAll {
             //code
            }
            tableView.reloadData()
        }
    }
    
}

