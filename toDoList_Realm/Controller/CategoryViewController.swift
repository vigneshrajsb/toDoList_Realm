//
//  ViewController.swift
//  toDoList_Realm
//
//  Created by Vigneshraj Sekar Babu on 5/21/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    @IBOutlet weak var countLabel: UILabel!
    var array : [String] = []
  //  let realm = try! Realm()
    var realm : Realm?
    var category : Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        realm = try! Realm()
        fetchData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard  let navBar = navigationController?.navigationBar else {
            fatalError("no nav bar for Category Table VC")
        }
        guard let color = UIColor(hexString: "27C2F8") else { fatalError("UI color missing in Category table VC")}
        navBar.barTintColor = color
        navBar.tintColor = ContrastColorOf(color, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(color, returnFlat: true)]
        
        tableView.reloadData()
    }
    
    //MARK: - tableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = "\(category?[indexPath.row].categoryName ?? "Nothing here")  (\(category![indexPath.row].toDos.filter("completed == %@", false).count))"
     cell.backgroundColor = UIColor(hexString: category?[indexPath.row].categoryColor ?? "FFFFFF")
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
                    tempCategory.categoryColor = UIColor.randomFlat.hexValue()
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
    
    
    override func delete(at indexPath: IndexPath) {
        if let paramCategory = self.category?[indexPath.row] {
            do {
                try realm?.write {
                    realm?.delete(paramCategory)
                }
            }
            catch {
                print("error while deleting category : \(error)")
            }
        }
    }

}


