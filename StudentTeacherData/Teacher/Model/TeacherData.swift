//
//  TeacherData.swift
//  StudentTeacherData
//
//  Created by Vishu on 30/01/24.
//

import UIKit
import CoreData

class TeacherData: NSObject {
    
    var teacherOBJ:[Teacher] = []
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // Add Teacher Object returns Bool as result
    func insertDataObject(firstName:String, lastName:String, course:String) -> Bool{
       
        if let context = appDelegate?.persistentContainer.viewContext {
            let teacherObject = Teacher(context: context)
            teacherObject.firstname = firstName
            teacherObject.lastname = lastName
            teacherObject.course = course

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
    
    // fetch Teacher Object returns array of teachers
    func fetchDataObjec() -> [Teacher] {
        if let context = appDelegate?.persistentContainer.viewContext {
            let fetchTeachers: NSFetchRequest<Teacher> = Teacher.fetchRequest()
            do {
                teacherOBJ = try context.fetch(fetchTeachers)
            } catch {
                print("Error fetching student object: \(error.localizedDescription)")
            }
        }
        return teacherOBJ
    }
    
    // save Existing Teacher Object expects Teacher Object as input and returns result
    func updateDataObject(teachers: Teacher?, teacherFname:String, teacherLname:String, student:[Student], teacherCourse:String) -> Bool{
        if let context = appDelegate?.persistentContainer.viewContext {
            // update Teacher object
            teachers?.firstname = teacherFname
            teachers?.lastname = teacherLname
            teachers?.student =  NSSet(array: student)
            teachers?.course = teacherCourse
            
            do {
                try context.save()
                return true
            } catch {
                print("Error while saving Student profile! \(error.localizedDescription)")
            }
        }
        return false
    }
    
    // delete teacher Object expects teacher object as input and returns result
    func deleteDataObject(teachers: Teacher?) -> Bool{
        if let context = appDelegate?.persistentContainer.viewContext {
            context.delete(teachers!)
            do {
                try context.save()
                return true
            } catch {
                print("Error while deleting Student profile! \(error.localizedDescription)")
            }
        }
        return false
    }
        
    // fetch students from teacher object
    // expects teacher object as input
    // returns students array
    func fetchStudentfromTeacher(teachers: Teacher?) -> [String]{
        var studentsName = [String]()
        if let students = teachers?.student as? Set<Student> {
            for student in students {
                let fetchedStudentName = "\(student.name ?? "")"
                studentsName.append(fetchedStudentName)
            }
        }
        return studentsName
    }
}
