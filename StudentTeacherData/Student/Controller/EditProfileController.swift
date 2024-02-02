//
//  EditProfileController.swift
//  StudentTeacherData
//
//  Created by Vishu on 30/01/24.
//

import UIKit

class EditProfileController: UIViewController {

    // Initalize Student Object for Navigation controller to pass Single Student as Object to Display that specific Student in EditProfileController
    var students : Student?
    // empty Teacher Object Array to add Teachers when selected
    var teachersName : [Teacher] = []
    // call StudentData Model
    let studentDataModel = StudentData()
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var teacherText: UITextField!
    @IBOutlet weak var courseText: UITextField!
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
        nameText.layer.cornerRadius = 8
        nameText.layer.borderWidth = 1.0
        ageText.layer.cornerRadius = 8
        ageText.layer.borderWidth = 1.0
        idText.layer.cornerRadius = 8
        idText.layer.borderWidth = 1.0
        teacherText.layer.cornerRadius = 8
        teacherText.layer.borderWidth = 1.0
        courseText.layer.cornerRadius = 8
        courseText.layer.borderWidth = 1.0
        deleteButton.layer.cornerRadius = 8
        deleteButton.layer.borderWidth = 1.5
    }

    func setupTextFields(){
        nameText.text = students?.name
        ageText.text = "\(Int16(students?.age ?? 0))"
        idText.text = "\(Int16(students?.id ?? 0))"
        teacherText.text = studentDataModel.fetchTeacherfromStudent(students: students).joined(separator: ", ")
        courseText.text = students?.course
        
        // Add Tap Gesture at Teacher TextField to replicate a button Tap
        captureTapGesture()
    }
    
    func textFieldDelegate(){
        nameText.delegate = self
        ageText.delegate = self
        idText.delegate = self
        teacherText.delegate = self
        courseText.delegate = self
    }
    
    func captureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        
        teacherText.isUserInteractionEnabled = true
        teacherText.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(){
        // reset teacher textField before switching to new Controller
        teacherText.text = ""
        let teacherListController = fetchTeacherController()
        teacherListController.delegate = self
        teacherListController.is_FromNavigation = true
        self.navigationController?.pushViewController(teacherListController, animated: true)
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
        let updateDataObject = studentDataModel.updateDataObject(students: students, name: nameText.text ?? "Name", age: Int16(ageText.text ?? "") ?? 0, id: Int16(idText.text ?? "") ?? 0, teachers: teachersName, course: courseText.text ?? "Course")
        
        let okay = UIAlertAction(title: "Okay", style: .default , handler: {_ in
            if updateDataObject.0 == true {
                let teacherDataModel = TeacherData()
                teacherDataModel.resetObjectState(teachers: self.teachersName)
                self.navigationController?.popViewController(animated: true)
            }
        })
        alertUser(title: updateDataObject.1, message: updateDataObject.2, action: okay)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to delete \(students?.name ?? "Name") Profile", message: "Following will Delete user \(students?.name ?? "Name") Profile, Action cannot be Reverted", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default, handler: {_ in
            let deleteDataObject = self.studentDataModel.deleteDataObject(students: self.students)
            let okay = UIAlertAction(title: "Okay", style: .default , handler: {_ in
                if deleteDataObject.0 == true {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            self.alertUser(title: deleteDataObject.1, message: deleteDataObject.2, action: okay)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(okay)
        alert.addAction(cancel)
        alert.view.tintColor = UIColor.black
        self.present(alert, animated: true)
    }
    
    func alertUser(title: String, message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(action)
        alert.view.tintColor = UIColor.black
        self.present(alert, animated: true)
    }
}

extension EditProfileController: UITextFieldDelegate, TeacherSelectionDelegate {
    func didSelectTeacher(_ teacher: [Teacher]) {
        teachersName = teacher
        updateTeacherTextField()
    }

    private func updateTeacherTextField() {
        let teacherNames = teachersName.map { "\($0.firstname ?? "") \($0.lastname ?? "")" }
        teacherText.text = teacherNames.joined(separator: ", ")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
