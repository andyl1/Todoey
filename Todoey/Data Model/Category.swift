//
//  Category.swift
//  Todoey
//
//  Created by Andy Lee on 30/1/19.
//  Copyright © 2019 Appinfy. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
}

