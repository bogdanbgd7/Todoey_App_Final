//
//  ViewController.swift
//  Todoey
//
//  Created by Bogdan Ponocko on 8/16/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{ //changed VC to TableVC
    
    let itemArray = ["Find Mike", "Buy milk", "Buy gas", "Buy sneakers"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.tableview.delegate = self
//        self.tableview.datasource = self
    }
    
    //MARK - TableView DataSource METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - TableView Delegate METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
        
         //everytime i click on item, it displays checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true) //sminka, ne ostaje sivo kad se oznaci item, vec se vrati u belo
        
        
    }

    


}

