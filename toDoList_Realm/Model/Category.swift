//
//  Catergory.swift
//  toDoList_Realm
//
//  Created by Vigneshraj Sekar Babu on 5/21/18.
//  Copyright © 2018 Vigneshraj Sekar Babu. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var categoryName = ""
    @objc dynamic var categoryColor = ""
     var toDos = List<ToDoItems>()
}
