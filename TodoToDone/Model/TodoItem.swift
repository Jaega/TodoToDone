//
//  TodoItem.swift
//  TodoToDone
//
//  Created by Xinzhao Li on 7/16/19.
//  Copyright © 2019 Jaega. All rights reserved.
//

import Foundation

class TodoItem: Codable {
    var title: String = ""
    var checked: Bool = false
    
    init(name: String, done: Bool) {
        title = name
        checked = done
    }
}
