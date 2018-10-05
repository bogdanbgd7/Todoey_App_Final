//
//  Item.swift
//  Todoey
//
//  Created by Bogdan Ponocko on 8/27/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
   
    
    //RELATIONSHIP - one item has one Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
