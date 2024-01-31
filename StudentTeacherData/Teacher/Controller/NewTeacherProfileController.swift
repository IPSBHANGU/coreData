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
        if firstNameText.text?.isEmpty ?? true {
            alertUserWithoutAction(title: "Enter First Name", message: "First Name cannot be empty!", alertColor: .red)
            firstNameText.layer.borderColor = UIColor.red.cgColor
            return false
        } else if lastNameText.text?.isEmpty ?? true {
            alertUserWithoutAction(title: "Enter Last Name", message: "Last Name cannot be empty!", alertColor: .red)
            lastNameText.layer.borderColor = UIColor.red.cgColor
            return false
        } else if courseText.text?.isEmpty ?? true {
            alertUserWithoutAction(title: "Select Course", message: "Teacher Course cannot be kept empty!", alertColor: .red)
            courseText.layer.borderColor = UIColor.red.cgColor
            return false
        } else {
            return true
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if checkTextFeilds() == true {
            if (TeacherDataModel.insertDataObject(firstName: firstNameText.text ?? "First Name", lastName: lastNameText.text ?? "Last Name", course: courseText.text ?? "Course")) == true {
                let okay = UIAlertAction(title: "Okay", style: .default , handler: {_ in
                    // reset Feilds after data insertion
                    self.resetTextFeilds()
                    self.navigationController?.popViewController(animated: true)
                })
                alertUser(title: "Teacher Profile Created !", message: "New Teacher profile was generated successfully", action: okay, alertColor: .black)
            } else {
                
                let okay = UIAlertAction(title: "Okay", style: .default)
                alertUser(title: "Teacher Profile Failed to create !", message: "There was an error while generation of new Teacher Profile", action: okay, alertColor: .red)
            }
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
