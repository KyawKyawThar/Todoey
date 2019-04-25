//
//  Category.swift
//  Todoey
//
//  Created by Kyaw Kyaw on 4/19/19.
//  Copyright © 2019 Kyaw Kyaw Thar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
   @objc dynamic var name: String = ""
    
    let Items = List<Item>()
}
