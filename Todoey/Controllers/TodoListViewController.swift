//
//  ViewController.swift
//  Todoey
//
//  Created by Bogdan Ponocko on 8/16/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import UIKit
//deleted import CoreData
import RealmSwift

class TodoListViewController: UITableViewController{ 
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? { //after selectedCategory got value, didSet gonna trigger
        didSet{
            
           loadItems()
            
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        print("LINK TO REALM \(Realm.Configuration.defaultConfiguration.fileURL!)")

    }
    
    //MARK: - TableView DataSource METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none //if item.done == true -> cell = .checkmark
            
        }
        else {
            
            cell.textLabel?.text = "No items added!"
            
        }
        
        
        return cell
        
    }
    
    //MARK: - TableView Delegate METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //kada korisnik izabere jedan row sta se desi :
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Neki error \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) //sminka, ne ostaje sivo kad se oznaci item, vec se vrati u belo
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if let item = todoItems?[indexPath.row] {
                try! realm.write {
                    realm.delete(item)
                }
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        }
    }
    
    //MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert) //poruka
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //akcija
            //what will happen once the user clicks the ADD item button on our alert
            
            if let currentCategory = self.selectedCategory {
                
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date() //every new item created gets current date when click on Add Item action
                    currentCategory.items.append(newItem)
                }
                
            }
                catch {
                    print("Error saving new items! \(error)")
                }
        }
            
            self.tableView.reloadData()

            
            
            
//            self.saveItems(item: newItem)
            
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
            alert.addAction(action)
            
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manipulation Methods
    
  
    
    //----------------------------------------------------------------
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    


}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {

                searchBar.resignFirstResponder()
            }


        }
    }

}








