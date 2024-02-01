//
//  StudentListViewCell.swift
//  StudentTeacherData
//
//  Created by Vishu on 29/01/24.
//

import UIKit

class StudentListViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var course: UILabel!
    
    // Object for Student
    var selectedStudent:Student?
    @IBOutlet weak var checkMarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkMarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(student:Student, isCheckMarkHidden:Bool = true) {
        selectedStudent = student
        var teachersName = [String]()
        if let teachers = selectedStudent?.teacher as? Set<Teacher> {
            for teacher in teachers {
                let fetchedTeacherName =  "\(teacher.firstname ?? "") \(teacher.lastname ?? "")"
                teachersName.append(fetchedTeacherName)
            }
        }
        
        name.text = student.name
        age.text = "\(Int16(student.age))"
        id.text = "\(Int16(student.id))"
        teacher.text = teachersName.joined(separator: ", ")
        course.text = student.course
        checkMarkButton.isHidden = isCheckMarkHidden
    }
    

    @IBAction func checkmarkAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectedStudent?.isSelected = sender.isSelected
    }
    
}
