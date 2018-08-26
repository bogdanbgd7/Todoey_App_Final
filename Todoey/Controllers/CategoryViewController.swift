//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bogdan Ponocko on 8/25/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import UIKit
import  CoreData

class CategoryViewController: UITableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //must! in order to use CRUD
    var categoryArray = [Category]() //array of categories initialised as empty array
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
    }
    
    
    //MARK: - Data Manipulation Methdods
    
    func saveItems() {
        
        do {
            
            try     context.save()
            
        }
        catch {
            print("Error saving context ! \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    //----------------------------------------------------------------
    
    
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        }
        catch{
            print("Error loading items! \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert) //poruka
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in //akcija
            //what will happen once the user clicks the ADD item button on our alert
            
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
        
            self.saveItems()
            
            print(self.categoryArray)
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
        
    }
    
    
    
    
    
    
}
