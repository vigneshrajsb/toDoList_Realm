//
//  ViewController.swift
//  toDoList_Realm
//
//  Created by Vigneshraj Sekar Babu on 5/21/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit
import  RealmSwift

class CategoryViewController: UITableViewController {

    @IBOutlet weak var countLabel: UILabel!
    var array : [String] = []
  //  let realm = try! Realm()
    var realm : Realm?
    var category : Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
         realm = try! Realm()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      tableView.reloadData()
    }
    
    //MARK: - tableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        //cell.textLabel?.text = array[indexPath.row]
        cell.textLabel?.text = "\(category?[indexPath.row].categoryName ?? "Nothing here")  (\(category![indexPath.row].toDos.filter("completed == %@", false).count))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "toDoList", sender: self)
    }
    
    //MARK: - Add method
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textbox = UITextField()
        let alert = UIAlertController(title: "New Category", message: "Add a new entry", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let textEntered = textbox.text {
                if textEntered.count > 0 {
                    let tempCategory = Category()
                    tempCategory.categoryName = textEntered
                    self.saveData(paramCategory: tempCategory)
                }
                
            }
        }
        alert.addAction(action)
        alert.addTextField { (textfield) in
            textbox = textfield
            textfield.placeholder = "type in what you want"
        }
        present(alert, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toDoVC = segue.destination as! ToDoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            toDoVC.selectedCategory = category?[indexPath.row]
        }
    }
    
    //MARK: - Data
    
    func saveData(paramCategory : Category) {
             // if text.count > 0 {
        
            do {
                try  realm?.write {
                    realm?.add(paramCategory)
                }

            } catch {
                print("Error while writing added category to Realm : \(error)")
            }
        //}
        tableView.reloadData()
    }
    
    func fetchData() {
        category = realm?.objects(Category.self)
    }

}

