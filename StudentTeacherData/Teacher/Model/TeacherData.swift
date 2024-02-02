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
    func insertDataObject(firstName:String, lastName:String, course:String) -> (Bool,String,String){
       
        if let context = appDelegate?.persistentContainer.viewContext {
            let teacherObject = Teacher(context: context)
            teacherObject.firstname = firstName
            teacherObject.lastname = lastName
            teacherObject.course = course

            do {
                try context.save()
                return (true, "Teacher Profile Created !","New Teacher profile was generated successfully")
            } catch {
                print("Error while inserting new data Object! \(error.localizedDescription)")
            }
        }
        return (false, "Student Profile Failed to create !", "There was an error while generation of new Student Profile")
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
    func updateDataObject(teachers: Teacher?, teacherFname:String, teacherLname:String, student:[Student], teacherCourse:String) -> (Bool,String,String){
        if let context = appDelegate?.persistentContainer.viewContext {
            // update Teacher object
            teachers?.firstname = teacherFname
            teachers?.lastname = teacherLname
            teachers?.student =  NSSet(array: student)
            teachers?.course = teacherCourse
            
            do {
                try context.save()
                return (true, "Teacher Profile Updated !","Teacher profile was Updated successfully !")
            } catch {
                print("Error while saving Student profile! \(error.localizedDescription)")
            }
        }
        return (false, "Teacher Profile Failed to update !", "There was an error while updating of new Teacher Profile")
    }
    
    // delete teacher Object expects teacher object as input and returns result
    func deleteDataObject(teachers: Teacher?) -> (Bool,String,String){
        if let context = appDelegate?.persistentContainer.viewContext {
            context.delete(teachers!)
            do {
                try context.save()
                return (true, "Teacher Profile Deleted !","Teacher profile was Deleted successfully !")
            } catch {
                print("Error while deleting Teacher profile! \(error.localizedDescription)")
            }
        }
        return (false, "Teacher Profile Failed to delete !", "There was an error while deleting Teacher Profile")
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
    
    // Function to return Teacher object Array on bases of is_Selected Bool
    func addSelectedStudents(teachers:[Teacher]=[], students:Student?) -> [Teacher]{
        var teachersArr:[Teacher] = []

        if let teacher = students?.teacher as? Set<Teacher> {
            teachersArr = Array(teacher)
        }

        for teacher in teachers {
            if teacher.isSelected == true {
                teachersArr.append(teacher)
            }
        }
        return teachersArr
    }
    
    // reset is_Selected bool for Teacher Object
    func resetObjectState(teachers: [Teacher] = []){
        for teacher in teachers {
            if teacher.isSelected == true {
                teacher.isSelected = false
            }
        }
    }
    
    // Verify Text Field
    func isEmptyTextField(textField: UITextField?) -> (Bool,String,String){
        if textField?.text?.isEmpty == true {
            return (true, "Empty TextField", "Cannot continue with empty TextFiled")
        }
        return (false, " ", " ")
    }
}
