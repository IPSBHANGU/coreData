//
//  StudentListViewCell.swift
//  StudentTeacherData
//
//  Created by Inderpreet on 29/01/24.
//

import UIKit

class StudentListViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var course: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(studentName: String?, studentAge: Int, studentId: Int, studentCourse: String?, studentTeacherName: String?) {
        name.text = studentName
        age.text = "\(studentAge)"
        id.text = "\(studentId)"
        teacher.text = studentTeacherName
        course.text = studentCourse
    }
    
}
