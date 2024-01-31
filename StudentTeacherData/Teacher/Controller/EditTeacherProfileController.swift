//
//  EditTeacherProfileController.swift
//  StudentTeacherData
//
//  Created by Vishu on 30/01/24.
//

import UIKit

class EditTeacherProfileController: UIViewController {
    
    // Initalize Teacher Object for Navigation controller to pass Single Teacher as Object to Display that specific Teacher in EditTeacherProfileController
    
    var teachers : Teacher?
    
    // call TeacherData Model
    let teacherDataModel = TeacherData()
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var courseText: UITextField!
    @IBOutlet weak var studentText: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modifyNavigationBar()
        updateCornerRadius()
        updateButtonAppearance()
        setupTextFields()
        textFieldDelegate()
        // Do any additional setup after loading the view.
    }

    func modifyNavigationBar(){
        self.navigationItem.title = "Edit Student Profile"
        let saveButton = UIBarButtonItem(systemItem: .save)
        saveButton.target = self
        saveButton.action = #selector(saveAction(_:))
        self.navigationItem.rightBarButtonItem = saveButton
    }

    func updateCornerRadius(){
        firstNameText.layer.cornerRadius = 8
        firstNameText.layer.borderWidth = 1.0
        lastNameText.layer.cornerRadius = 8
        lastNameText.layer.borderWidth = 1.0
        studentText.layer.cornerRadius = 8
        studentText.layer.borderWidth = 1.0
        courseText.layer.cornerRadius = 8
        courseText.layer.borderWidth = 1.0
        deleteButton.layer.cornerRadius = 8
        deleteButton.layer.borderWidth = 1.5
    }

    func setupTextFields(){
        firstNameText.text = teachers?.firstname
        lastNameText.text = teachers?.lastname
        studentText.text = "Student"
        courseText.text = teachers?.course
    }
    
    func textFieldDelegate(){
        firstNameText.delegate = self
        lastNameText.delegate = self
        studentText.delegate = self
        courseText.delegate = self
    }
    
    func alertUser(title: String, message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(action)
        alert.view.tintColor = UIColor.black
        self.present(alert, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateButtonAppearance(){
        deleteButton.layer.borderColor = UIColor.red.cgColor
    }
    
    @objc func saveAction(_ sender: Any) {
        if (teacherDataModel.updateDataObject(teachers: teachers, teacherFname: firstNameText.text ?? "First Name", teacherLname: lastNameText.text ?? "Last Name", teacherCourse: courseText.text ?? "Course")) == true {
            let okay = UIAlertAction(title: "Okay", style: .default , handler: {_ in
                self.navigationController?.popViewController(animated: true)
            })
            alertUser(title: "Teacher Profile Updated !", message: "Student profile was Updated successfully !", action: okay)
        } else {
            let okay = UIAlertAction(title: "Okay", style: .default)
            alertUser(title: "Teacher Profile Failed to update !", message: "There was an error while updating of new Student Profile", action: okay)
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to delete \(teachers?.firstname ?? "First Name") \(teachers?.lastname ?? "Last Name") Profile", message: "Following will Delete user \(teachers?.firstname ?? "First Name") \(teachers?.lastname ?? "Last Name") Profile, Action cannot be Reverted", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default, handler: {_ in
            if (self.teacherDataModel.deleteDataObject(teachers: self.teachers)) == true {
                let okay = UIAlertAction(title: "Okay", style: .default , handler: {_ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.alertUser(title: "Teacher Profile Deleted !", message: "Teacher profile was Deleted successfully !", action: okay)
            } else {
                let okay = UIAlertAction(title: "Okay", style: .default)
                self.alertUser(title: "Teacher Profile Failed to delete !", message: "There was an error while deleting Teacher Profile", action: okay)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(okay)
        alert.addAction(cancel)
        alert.view.tintColor = UIColor.black
        self.present(alert, animated: true)
    }
    
}

extension EditTeacherProfileController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
