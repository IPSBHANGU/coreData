//
//  TeacherListViewCell.swift
//  StudentTeacherData
//
//  Created by Inderpreet on 30/01/24.
//

import UIKit

class TeacherListViewCell: UITableViewCell {
    
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // Object for Teacher
    var selectedTeacher:Teacher?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(teacher:Teacher, isCheckMarkHidden:Bool = true) {
        selectedTeacher = teacher
        firstName.text = teacher.firstname
        lastName.text = teacher.lastname
        course.text = teacher.course
        button.isHidden = isCheckMarkHidden
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectedTeacher?.isSelected = sender.isSelected
    }
    
}
