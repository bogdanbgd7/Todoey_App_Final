//
//  Category.swift
//  Todoey
//
//  Created by Bogdan Ponocko on 8/27/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object { //when inheriting Object, it means that Category is now Realm Object.
    
    @objc dynamic var name : String  = ""
    @objc dynamic var colour : String = "" 
    
    //RELATIONSHIP - each Category has a lot of items.
    let items = List<Item>()                            //similar to let array = Array<Int>
    
    
    
    
}
