//
//  Teacher+CoreDataProperties.swift
//  StudentTeacherData
//
//  Created by Inderpreet on 29/01/24.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var course: String?
    @NSManaged public var isSelected: Bool
    @NSManaged public var student: NSSet?

}

// MARK: Generated accessors for student
extension Teacher {

    @objc(addStudentObject:)
    @NSManaged public func addToStudent(_ value: Student)

    @objc(removeStudentObject:)
    @NSManaged public func removeFromStudent(_ value: Student)

    @objc(addStudent:)
    @NSManaged public func addToStudent(_ values: NSSet)

    @objc(removeStudent:)
    @NSManaged public func removeFromStudent(_ values: NSSet)

}

extension Teacher : Identifiable {

}
