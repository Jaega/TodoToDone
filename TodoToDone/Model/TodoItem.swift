//
//  TodoItem.swift
//  TodoToDone
//
//  Created by Xinzhao Li on 7/19/19.
//  Copyright © 2019 Jaega. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated: Date?
    // inverse relationship
    let parentCategory = LinkingObjects(fromType: Category.self, property: "todoItems")
}
