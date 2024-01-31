//
//  Student+CoreDataProperties.swift
//  StudentTeacherData
//
//  Created by Vishu on 29/01/24.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var age: Int16
    @NSManaged public var course: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var teacher: NSSet?

}

// MARK: Generated accessors for teacher
extension Student {

    @objc(addTeacherObject:)
    @NSManaged public func addToTeacher(_ value: Teacher)

    @objc(removeTeacherObject:)
    @NSManaged public func removeFromTeacher(_ value: Teacher)

    @objc(addTeacher:)
    @NSManaged public func addToTeacher(_ values: NSSet)

    @objc(removeTeacher:)
    @NSManaged public func removeFromTeacher(_ values: NSSet)

}

extension Student : Identifiable {

}
