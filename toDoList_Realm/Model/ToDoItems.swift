//
//  toDoItems.swift
//  toDoList_Realm
//
//  Created by Vigneshraj Sekar Babu on 5/21/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItems: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var completed : Bool = false
    @objc dynamic var dateCreated : Date? = nil
    @objc dynamic var dueDate : Date? = nil
    var parentCategory = LinkingObjects(fromType: Category.self, property: "toDos")
}
