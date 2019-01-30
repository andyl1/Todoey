//
//  Item.swift
//  Todoey
//
//  Created by Andy Lee on 30/1/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
