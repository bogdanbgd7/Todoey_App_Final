//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bogdan Ponocko on 8/25/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?     //Result - Collection type
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadCategories()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 //Nil Coalescing Operator -- if count is nil, then return 1 instead of nil
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        let category = categories?[indexPath.row] //izabrani row
        
        cell.textLabel?.text = category?.name ?? "No Categories Added yet!"
        cell.backgroundColor = UIColor(hexString: category?.colour ?? "1D9BF6")
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        cell.delegate = self
        
        
 
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
            newCategory.colour = UIColor.randomFlat.hexValue()
           
            
        
            self.save(category: newCategory)
            
            print(self.categories!)
        }
        
        alert.addAction(action)
        

        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            
            textField = alertTextField
        }
        
        //when user click outside of alert, to dismiss it - from stackoverflow
        self.present(alert, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
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

extension CategoryViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let item = self.categories?[indexPath.row] {
                try! self.realm.write {
                    self.realm.delete(item)
                    action.fulfill(with: .delete)
                }
                //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            
            //tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
   
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
}




























