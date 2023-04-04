//
//  TodoList+CoreDataProperties.swift
//  practice_app
//
//  Created by zed on 09.03.23.
//
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?

}

extension TodoList : Identifiable {

}
