//
//  HomeContoller.swift
//  StudentTeacherData
//
//  Created by Vishu on 29/01/24.
//

import UIKit

class HomeContoller: UIViewController {
    
    
    @IBOutlet weak var addStudentButton: UIButton!
    @IBOutlet weak var fetchStudentButton: UIButton!
    @IBOutlet weak var addTeacherButton: UIButton!
    @IBOutlet weak var fetchTeacherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButtonRadius()
        // Do any additional setup after loading the view.
    }
    
    func addButtonRadius(){
        addStudentButton.layer.cornerRadius = 8
        fetchStudentButton.layer.cornerRadius = 8
        addTeacherButton.layer.cornerRadius = 8
        fetchTeacherButton.layer.cornerRadius = 8
    }
    
    // Add New Student Profile
    @IBAction func addStudentAction(_ sender: UIButton) {
        let newStudentController = NewStudentProfile()
        navigationController?.pushViewController(newStudentController, animated: true)
    }
    
    @IBAction func fetchStudentAction(_ sender: UIButton) {
        let fetchStudentController = fetchStudentController()
        navigationController?.pushViewController(fetchStudentController, animated: true)
    }
    
    @IBAction func addTeacherAction(_ sender: Any) {
        let newTeacherController = NewTeacherProfileController()
        navigationController?.pushViewController(newTeacherController, animated: true)
    }
    
    
    @IBAction func fetchTeacherAction(_ sender: Any) {
        let fetchTeacherController = fetchTeacherController()
        navigationController?.pushViewController(fetchTeacherController, animated: true)
    }
    
}
