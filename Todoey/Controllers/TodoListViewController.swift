//
//  ViewController.swift
//  Todoey
//
//  Created by Bogdan Ponocko on 8/16/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController{ 
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory : Category? { //after selectedCategory got value, didSet gonna trigger
        didSet{
            
            loadItems()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        

    }
    
    //MARK: - TableView DataSource METHODS
    
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
        cell.accessoryType = item.done ? .checkmark : .none //if item.done == true -> cell = .checkmark
        
        
        return cell
        
    }
    
    //MARK: - TableView Delegate METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //kada korisnik izabere jedan row sta se desi :
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //ako nije stikliran - stikliraj na klik : ako jeste - odstikliraj na klik
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) //sminka, ne ostaje sivo kad se oznaci item, vec se vrati u belo
        
        
    }
    
    //MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert) //poruka
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //akcija
            //what will happen once the user clicks the ADD item button on our alert
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory // parentCategory is relationship name from database
            self.itemArray.append(newItem)
            
            //self.itemArray.append(textField.text!) //dodaj tekst iz fieldText-a u niz
            
            self.saveItems()
            
            print(self.itemArray)
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
            alert.addAction(action)
            
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manipulation Methods
    
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
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            
            request.predicate = categoryPredicate
            
        }
        
        
        do {
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error loading items! \(error)")
        }
        
        tableView.reloadData()

    }
    
    


}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicateB  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicateB)
        
        
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








