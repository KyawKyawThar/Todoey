//
//  ViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw on 3/28/19.
//  Copyright © 2019 Kyaw Kyaw Thar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var ItemArray = [Items]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") as Any)
        
	        loadItem()
        
        
//
//        if let items = userDefault.array(forKey: "TodoListArray") as? [String] {
//            ItemArray = items
//        }
    }
  
    //Mark - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return ItemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
         let Items = ItemArray[indexPath.row]
        
        cell.textLabel?.text = Items.title
 
        cell.accessoryType = Items.done == true ? . checkmark : .none
      
        
        
        return cell
    }
    
    // Mark - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(ItemArray[indexPath.row])
        
       ItemArray[indexPath.row].done = !ItemArray[indexPath.row].done
        
     saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark - Add New Items
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when user clicks the Add button on our alert!
            
            let newItems = Items(context: self.context)
            newItems.title = textField.text!
            newItems.done = false
            
            self.ItemArray.append(newItems)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // Mark - Model Manipulate Methods
    
    func saveItems () {
    
       
        
        do {
           try context.save()
        } catch {
          print("Error saveing context\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItem(with request: NSFetchRequest<Items> = Items.fetchRequest()) {

      //  let request:NSFetchRequest<Items> = Items.fetchRequest()
        

            do{
              ItemArray = try context.fetch(request)
            } catch {
               print("Error fetching data from context\(error)")
            }
        tableView.reloadData()
        }
    
}
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest <Items> = Items.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadItem(with: request)
       
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
           
        }
    }
}

