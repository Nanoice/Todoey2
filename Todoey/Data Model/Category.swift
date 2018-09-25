//
//  Category.swift
//  Todoey
//
//  Created by Ian Sung on 2018/9/21.
//  Copyright © 2018 Ian Sung. All rights reserved.
//

import Foundation
import RealmSwift

class Cateogry: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}


