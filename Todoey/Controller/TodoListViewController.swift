//
//  ViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw on 3/28/19.
//  Copyright © 2019 Kyaw Kyaw Thar. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        
        didSet {
            
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") as Any)
        
        
        
        
        
        
    }
    
    //Mark - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if  let Item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = Item.title
            
            // Tendary operator ===>
            // value = condition ? valueTrue : value False
            
            cell.accessoryType = Item.done == true ? . checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    // Mark - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems? [indexPath.row] {
            
            do {
                // Update Data
            try realm.write {
                
              //realm.delete(item)
                item.done = !item.done
            }
            } catch {
                print("Error saving done status\(error)")
            }
            tableView.reloadData()
        }
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Mark - Add New Items

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: " ", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when user clicks the Add button on our alert!
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.Items.append(newItem)
                    }
                } catch {
                    print("Error saving new items\(error)")
                }
                
            }
          
          self.tableView.reloadData()
            

        }

        alert.addTextField { (alertTextField) in

            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }

    // Mark - Model Manipulate Methods


    func loadItem() {
        
        todoItems = selectedCategory?.Items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


