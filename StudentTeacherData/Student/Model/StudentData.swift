//
//  StudentData.swift
//  StudentTeacherData
//
//  Created by Vishu on 29/01/24.
//

import UIKit
import CoreData

class StudentData: NSObject {
    
    var studentOBJ:[Student] = []
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // Add Student Object returns Bool as result
    func insertDataObject(name:String, age:Int16, id:Int16, course:String, teachersName:[Teacher]?) -> (Bool,String,String){
       
        if let context = appDelegate?.persistentContainer.viewContext {
            let studentObject = Student(context: context)
            studentObject.name = name
            studentObject.age = age
            studentObject.id = id
            studentObject.course = course
            studentObject.teacher = NSSet(array: teachersName!)
            
            do {
                try context.save()
                return (true, "Student Profile Created !","New Student profile was generated successfully")
            } catch {
                print("Error while inserting new data Object! \(error.localizedDescription)")
            }
        }
        return (false, "Student Profile Failed to create !", "There was an error while generation of new Student Profile")
    }
    
    // fetch Student Object resturns array of students
    func fetchDataObject() -> [Student] {
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
    func updateDataObject(students: Student?, name:String, age:Int16, id:Int16, teachers:[Teacher], course:String) -> (Bool,String,String){
        if let context = appDelegate?.persistentContainer.viewContext {
            students?.name = name
            students?.age = age
            students?.id = id
            students?.teacher = NSSet(array: teachers)
            students?.course = course
            
            do {
                try context.save()
                return (true, "Student Profile Updated !","Student profile was Updated successfully !")
            } catch {
                print("Error while saving Student profile! \(error.localizedDescription)")
            }
        }
        return (false, "Student Profile Failed to update !", "There was an error while updating of new Student Profile")
    }
    
    // delete student Object expects student object as input and returns result
    func deleteDataObject(students: Student?) -> (Bool,String,String){
        if let context = appDelegate?.persistentContainer.viewContext {
            context.delete(students!)
            do {
                try context.save()
                return (true, "Student Profile Deleted !","Student profile was Deleted successfully !")
            } catch {
                print("Error while deleting Student profile! \(error.localizedDescription)")
            }
        }
        return (false, "Student Profile Failed to delete !", "There was an error while deleting Student Profile")
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
    
    // Function to return Student object Array on bases of is_Selected Bool
    func addSelectedStudents(students : [Student] = [], teachers : Teacher?) -> [Student]{
        var studentsArr:[Student] = []

        if let student = teachers?.student as? Set<Student> {
            studentsArr = Array(student)
        }

        for student in students {
            if student.isSelected == true {
                studentsArr.append(student)
            }
        }
        return studentsArr
    }
    
    // reset is_Selected bool for Student Object
    func resetObjectState(students: [Student] = []){
        for student in students {
            if student.isSelected == true {
                student.isSelected = false
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
    
    // Verify if Chrachters are only INT
    func textFieldContainsOnlyInt(_ textField: UITextField) -> (Bool, String, String) {
        // Allow only digits and optional leading "-" sign
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "-"))
        let currentText = textField.text ?? ""
        let hasInvalidCharacters = currentText.rangeOfCharacter(from: allowedCharacters.inverted) != nil

        guard !hasInvalidCharacters else {
            return (false, "Invalid Chracters!", "Enter only be in Numbers!")
        }

        // Ensure the entire text can be converted to an integer (optional)
        guard let _ = Int(currentText) else {
            return (false, "Invalid Chracters!", "Enter only be in Numbers!")
        }
        return (true, " ", " ")
    }
}
