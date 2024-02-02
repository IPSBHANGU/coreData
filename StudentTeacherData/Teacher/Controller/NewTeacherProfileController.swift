//
//  NewTeacherProfileController.swift
//  StudentTeacherData
//
//  Created by Vishu on 30/01/24.
//

import UIKit

class NewTeacherProfileController: UIViewController {
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var courseText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // call TeacherData Model
    let TeacherDataModel = TeacherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modifyNavigationBar()
        updateCornerRadius()
        setupTextFields()
        // Do any additional setup after loading the view.
    }

    func modifyNavigationBar(){
        self.navigationItem.title = "New Teacher Profile"
    }

    func updateCornerRadius(){
        firstNameText.layer.cornerRadius = 8
        firstNameText.layer.borderWidth = 1.0
        lastNameText.layer.cornerRadius = 8
        lastNameText.layer.borderWidth = 1.0
        courseText.layer.cornerRadius = 8
        courseText.layer.borderWidth = 1.0
        submitButton.layer.cornerRadius = 8
    }
    
    func setupTextFields(){
        firstNameText.delegate = self
        lastNameText.delegate = self
        courseText.delegate = self
        
        // make FirstName field First Responder
        firstNameText.becomeFirstResponder()
    }
    
    func resetTextFeilds(){
        firstNameText.text = ""
        lastNameText.text = ""
        courseText.text = ""
    }
    
    func checkTextFeilds() -> Bool{
        let firstNameTextField = TeacherDataModel.isEmptyTextField(textField: firstNameText)
        let lastNameTextField = TeacherDataModel.isEmptyTextField(textField: lastNameText)
        let courseTextField = TeacherDataModel.isEmptyTextField(textField: courseText)
        
        if firstNameTextField.0 == true {
            alertUserWithoutAction(title: firstNameTextField.1, message: firstNameTextField.2, alertColor: .red)
            firstNameText.layer.borderColor = UIColor.red.cgColor
            firstNameText.shake()
            return false
        } else if lastNameTextField.0 == true {
            alertUserWithoutAction(title: lastNameTextField.1, message: lastNameTextField.2, alertColor: .red)
            lastNameText.layer.borderColor = UIColor.red.cgColor
            lastNameText.shake()
            return false
        } else if courseTextField.0 == true {
            alertUserWithoutAction(title: courseTextField.1, message: courseTextField.2, alertColor: .red)
            courseText.layer.borderColor = UIColor.red.cgColor
            courseText.shake()
            return false
        } else {
            return true
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if checkTextFeilds() == true {
            let insertObject = TeacherDataModel.insertDataObject(firstName: firstNameText.text ?? "First Name", lastName: lastNameText.text ?? "Last Name", course: courseText.text ?? "Course")
            let okay = UIAlertAction(title: "Okay", style: .default , handler: {_ in
                // reset Feilds after data insertion
                self.resetTextFeilds()
                if insertObject.0 == true {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            alertUser(title: insertObject.1, message: insertObject.2, action: okay, alertColor: .black)
        }
    }

    func alertUser(title: String, message: String, action: UIAlertAction, alertColor: UIColor) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(action)
        alert.view.tintColor = alertColor
        self.present(alert, animated: true)
    }
    
    func alertUserWithoutAction(title: String, message: String, alertColor: UIColor) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "Okay", style: .default)
        
        alert.addAction(okay)
        alert.view.tintColor = alertColor
        self.present(alert, animated: true)
    }
}

extension NewTeacherProfileController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
