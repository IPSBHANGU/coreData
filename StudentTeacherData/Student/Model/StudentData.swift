//
//  StudentData.swift
//  StudentTeacherData
//
//  Created by Inderpreet on 29/01/24.
//

import UIKit
import CoreData

class StudentData: NSObject {
    
    var studentOBJ:[Student] = []
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // Add Student Object returns Bool as result
    func insertDataObject(name:String, age:Int16, id:Int16, course:String, teachersName:[Teacher]?) -> Bool{
       
        if let context = appDelegate?.persistentContainer.viewContext {
            let studentObject = Student(context: context)
            studentObject.name = name
            studentObject.age = age
            studentObject.id = id
            studentObject.course = course
            studentObject.teacher = NSSet(array: teachersName!)
            
            do {
                try context.save()
                return true
            } catch {
                print("Error while inserting new data Object! \(error.localizedDescription)")
                return false
            }
        }
        return false
    }
    
    // fetch Student Object resturns array of students
    func fetchDataObjec() -> [Student] {
        if let context = appDelegate?.persistentContainer.viewContext {
            let fetchStudents: NSFetchRequest<Student> = Student.fetchRequest()
            do {
                studentOBJ = try context.fetch(fetchStudents)
            } catch {
                print("Error fetching student object: \(error.localizedDescription)")
            }
        }
        return studentOBJ
    }
    
    // save Existing Student Object expects Student Object as input and returns result
    func updateDataObject(students: Student?, name:String, age:Int16, id:Int16, teachers:[Teacher], course:String) -> Bool{
        if let context = appDelegate?.persistentContainer.viewContext {
            students?.name = name
            students?.age = age
            students?.id = id
            students?.teacher = NSSet(array: teachers)
            students?.course = course
            
            do {
                try context.save()
                return true
            } catch {
                print("Error while saving Student profile! \(error.localizedDescription)")
            }
        }
        return false
    }
    
    // delete student Object expects student object as input and returns result
    func deleteDataObject(students: Student?) -> Bool{
        if let context = appDelegate?.persistentContainer.viewContext {
            context.delete(students!)
            do {
                try context.save()
                return true
            } catch {
                print("Error while deleting Student profile! \(error.localizedDescription)")
            }
        }
        return false
    }
    
    // fetch teachers from student object
    // expects student object as input
    // returns teachers array
    func fetchTeacherfromStudent(students: Student?) -> [String]{
        var teachersName = [String]()
        if let teachers = students?.teacher as? Set<Teacher> {
            for teacher in teachers {
                let fetchedTeacherName = "\(teacher.firstname ?? "") \(teacher.lastname ?? "")"
                teachersName.append(fetchedTeacherName)
            }
        }
        return teachersName
    }
}
