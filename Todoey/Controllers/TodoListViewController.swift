//
//  ViewController.swift
//  Todoey
//
//  Created by Bogdan Ponocko on 8/16/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{ //changed VC to TableVC
    
//    var itemArray = ["Find Mike", "Buy milk", "Buy gas", "Buy sneakers"]
    
    var itemArray = [Item]()
    var defaults = UserDefaults.standard //singleton

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item() //new item is new object of the type Item
        newItem.title = "Find Mike"
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem2 = Item() //new item is new object of the type Item
        newItem2.title = "Buy Balenciaga"
        itemArray.append(newItem2)
        
        let newItem3 = Item() //new item is new object of the type Item
        newItem3.title = "Find AMG"
        itemArray.append(newItem3)
        
        
        
        if let items = defaults.array(forKey: "DataStorage") as? [Item] { // as? [String] - we are doing this to be more specific
            itemArray = items
        }
        

    }
    
    //MARK - TableView DataSource METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        
//              if item.done == true {
//                    cell.accessoryType = .checkmark
//               }
//                else {                                    //we will use ternary operator instead IF
//                    cell.accessoryType = .none
//               }
        
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        return cell
        
    }
    
    //MARK - TableView Delegate METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) //sminka, ne ostaje sivo kad se oznaci item, vec se vrati u belo
        
        
    }
    
    //MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert) //poruka
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //akcija
            //what will happen once the user clicks the ADD item button on our alert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //self.itemArray.append(textField.text!) //dodaj tekst iz fieldText-a u niz
            
            self.defaults.set(self.itemArray, forKey: "DataStorage")
            
            self.tableView.reloadData()
            
            print(self.itemArray)
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
            alert.addAction(action)
            
        self.present(alert, animated: true, completion: nil)
        
        
    }
    


}

