//
//  NewStudentProfile.swift
//  StudentTeacherData
//
//  Created by Vishu on 29/01/24.
//

import UIKit

class NewStudentProfile: UIViewController {

    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var teacherText: UITextField!
    @IBOutlet weak var courseText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // call StudentData Model
    let studentDataModel = StudentData()
    // empty Teacher Object Array to add Teachers when selected
    var teachersName : [Teacher] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modifyNavigationBar()
        updateCornerRadius()
        setupTextFields()
        // Do any additional setup after loading the view.
    }

    func modifyNavigationBar(){
        self.navigationItem.title = "New Student Profile"
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
        submitButton.layer.cornerRadius = 8
    }
    
    func setupTextFields(){
        nameText.delegate = self
        ageText.delegate = self
        idText.delegate = self
        teacherText.delegate = self
        courseText.delegate = self
        
        // make Name field First Responder
        nameText.becomeFirstResponder()
        
        // call tap Gesture for Teacher TextField
        captureTapGesture()
    }
    
    func resetTextFeilds(){
        nameText.text = ""
        ageText.text = ""
        idText.text = ""
        teacherText.text = ""
        courseText.text = ""
    }
    
    func checkTextFeilds() -> Bool{
        if nameText.text?.isEmpty ?? true {
            alertUserWithoutAction(title: "Enter Student Name", message: "Student Name cannot be empty!")
            nameText.layer.borderColor = UIColor.red.cgColor
            nameText.shake()
            return false
        } else if ageText.text?.isEmpty ?? true {
            alertUserWithoutAction(title: "Enter Student Age", message: "Student Age required!")
            ageText.layer.borderColor = UIColor.red.cgColor
            ageText.shake()
            return false
        } else if idText.text?.isEmpty ?? true {
            alertUserWithoutAction(title: "Enter Student ID", message: "Student ID required!")
            idText.layer.borderColor = UIColor.red.cgColor
            idText.shake()
            return false
        } else if teacherText.text?.isEmpty ?? true {
            alertUserWithoutAction(title: "Select Teacher", message: "Teacher Field cannot be empty!")
            teacherText.layer.borderColor = UIColor.red.cgColor
            teacherText.shake()
            return false
        } else if courseText.text?.isEmpty ?? true {
            alertUserWithoutAction(title: "Select Course", message: "Student Course cannot be kept empty!")
            courseText.layer.borderColor = UIColor.red.cgColor
            courseText.shake()
            return false
        } else if checkAgeTextField() == false {
            return false
        } else if checkIDTextField() == false {
            return false
        } else {
            return true
        }
    }
    
    func checkAgeTextField() -> Bool{
        if textFieldContainsOnlyInt(ageText){
            return true
        } else {
            alertUserWithoutAction(title: "Enter Valid Student Age", message: "Student Age should only be in Numbers!")
            ageText.layer.borderColor = UIColor.red.cgColor
            ageText.shake()
            return false
        }
        
    }
    
    func checkIDTextField() -> Bool{
        if textFieldContainsOnlyInt(idText){
            return true
        } else {
            alertUserWithoutAction(title: "Enter Valid Student ID", message: "Student ID should only be in Numbers!")
            idText.layer.borderColor = UIColor.red.cgColor
            idText.shake()
            return false
        }
    }
    
    func captureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        
        teacherText.isUserInteractionEnabled = true
        teacherText.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(){
        let teacherListController = fetchTeacherController()
        teacherListController.delegate = self
        teacherListController.is_FromNavigation = true
        self.navigationController?.pushViewController(teacherListController, animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if checkTextFeilds() == true {
            if (studentDataModel.insertDataObject(name: nameText.text ?? "Name", age: Int16(ageText.text ?? "") ?? 0+1, id: Int16(idText.text ?? "") ?? 0+1, course: courseText.text ?? "Course", teachersName: teachersName)) == true {
                let okay = UIAlertAction(title: "Okay", style: .default , handler: {_ in
                    // reset Feilds after data insertion
                    self.resetTextFeilds()
                    self.navigationController?.popViewController(animated: true)
                })
                alertUser(title: "Student Profile Created !", message: "New Student profile was generated successfully", action: okay)
            } else {
                
                let okay = UIAlertAction(title: "Okay", style: .default)
                alertUser(title: "Student Profile Failed to create !", message: "There was an error while generation of new Student Profile", action: okay)
            }
        }
    }
    
    func alertUser(title: String, message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }
    
    func alertUserWithoutAction(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Okay", style: .default)
        
        alert.addAction(okay)
        self.present(alert, animated: true)
        
    }
    
    func textFieldContainsOnlyInt(_ textField: UITextField) -> Bool {
        // Allow only digits and optional leading "-" sign
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "-"))
        let currentText = textField.text ?? ""
        let hasInvalidCharacters = currentText.rangeOfCharacter(from: allowedCharacters.inverted) != nil

        guard !hasInvalidCharacters else {
            return false
        }

        // Ensure the entire text can be converted to an integer (optional)
        guard let _ = Int(currentText) else {
            return false
        }

        return true
    }
}

extension NewStudentProfile: UITextFieldDelegate, TeacherSelectionDelegate {
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

extension UITextField {
    func shake(count: Int = 3, duration: TimeInterval = 0.35, translation: CGFloat = 3) {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.repeatCount = Float(count)
        animation.duration = duration
        animation.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),
            NSValue(caTransform3D:
                        CATransform3DMakeTranslation(-translation, 0, 0)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(translation, 0, 0)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(-translation, 0, 0)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(translation, 0, 0)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0))
        ]
        layer.add(animation, forKey: "shake")
    }
}
