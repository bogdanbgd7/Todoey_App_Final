//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bogdan Ponocko on 8/25/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?     //Result - Collection type
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadCategories()
        
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 //Nil Coalescing Operator -- if count is nil, then return 1 instead of nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No Categories Added yet!"
 
        return cell
        
    }
    
    
    //MARK: - Data Manipulation Methdods
    
    func save(category : Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
        }
        catch {
            print("Error saving context ! \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    //----------------------------------------------------------------
    
    
    func loadCategories() {
        
       categories = realm.objects(Category.self) //fetching all objects  from Category - EASY
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert) //poruka
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in //akcija
            //what will happen once the user clicks the ADD item button on our alert
            
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
           // self.categoryArray.append(newCategory)   no longer needed because of realm
            
        
            self.save(category: newCategory)
            
            print(self.categories!)
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
        
    }
    
    
    
    
    
    
}
