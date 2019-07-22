//
//  Category.swift
//  TodoToDone
//
//  Created by Xinzhao Li on 7/19/19.
//  Copyright © 2019 Jaega. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    // forward relationship
    let todoItems = List<TodoItem>()
}
