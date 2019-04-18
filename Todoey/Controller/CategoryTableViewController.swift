//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Kyaw Kyaw on 4/9/19.
//  Copyright © 2019 Kyaw Kyaw Thar. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //Mark: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //Mark - Data Manipulation Methods
        func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving categories\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest <Category> = Category.fetchRequest()
        
        do {
          categories =   try context.fetch(request)
        } catch {
            print("Error loading categories\(error)")
        }
        tableView.reloadData()
    }
    
   
    //Mark: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Cell", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true)
        
    }
    
}
