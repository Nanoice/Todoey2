//
//  Item.swift
//  Todoey
//
//  Created by Ian Sung on 2018/9/21.
//  Copyright © 2018 Ian Sung. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCateogry = LinkingObjects(fromType: Cateogry.self, property: "items")
}
