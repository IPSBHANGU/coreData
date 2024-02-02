//
//  fetchStudentController.swift
//  StudentTeacherData
//
//  Created by Vishu on 29/01/24.
//

import UIKit

protocol StudentSelectionDelegate: AnyObject {
    func didSelectStudent(_ student: [Student] )
}

class fetchStudentController: UIViewController {
    
    @IBOutlet weak var studentTableView: UITableView!
    
    // call StudentData Model
    let studentDataModel = StudentData()
    // empty student-Array object
    var students : [Student] = []
    // protocol-delegate
    weak var delegate: StudentSelectionDelegate?
    // Teachers Object for selecting Students
    var teachers : Teacher?
    // variable to enable button in Cells
    var is_FromNavigation:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        modifyNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStudentRecords()
    }
    
    func modifyNavigationBar(){
        self.navigationItem.title = "Student's List"
        guard is_FromNavigation == true else { return}
        let doneButton = UIBarButtonItem(systemItem: .done)
        doneButton.target = self
        doneButton.action = #selector(doneAction)
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneAction(){
        var studentsArr:[Student]?
        
        studentsArr = studentDataModel.addSelectedStudents(students: students, teachers: teachers)
        
        delegate?.didSelectStudent(studentsArr!)
        
        navigationController?.popViewController(animated: true)
    }
    
    func setTableView(){
        studentTableView.delegate = self
        studentTableView.dataSource = self
        studentTableView.register(UINib(nibName: "StudentListViewCell", bundle: .main), forCellReuseIdentifier: "studentlist")
        studentTableView.backgroundColor = UIColor.systemGroupedBackground
    }
    
    func fetchStudentRecords(){
        students = studentDataModel.fetchDataObject()
        studentTableView.reloadData()
    }
}

extension fetchStudentController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "studentlist", for: indexPath) as? StudentListViewCell else {
            return UITableViewCell()
        }
        
        let student = students[indexPath.row]
        cell.setCellData(student: student, isCheckMarkHidden: !is_FromNavigation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if is_FromNavigation == false {
            let selectedStudent = students[indexPath.row]
            let editProfile = EditProfileController()
            editProfile.students = selectedStudent
            self.navigationController?.pushViewController(editProfile, animated: true)
        }
    }
}
