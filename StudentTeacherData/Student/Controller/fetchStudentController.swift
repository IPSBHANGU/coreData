//
//  fetchStudentController.swift
//  StudentTeacherData
//
//  Created by Inderpreet on 29/01/24.
//

import UIKit

class fetchStudentController: UIViewController {
    
    @IBOutlet weak var studentTableView: UITableView!
    
    // call StudentData Model
    let studentDataModel = StudentData()
    
    // empty student-Array object
    var students : [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modifyNavigationBar()
        setTableView()
        fetchStudentRecords()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        studentTableView.reloadData()
    }
    
    func modifyNavigationBar(){
        self.navigationItem.title = "Student's List"
    }
    
    func setTableView(){
        studentTableView.delegate = self
        studentTableView.dataSource = self
        studentTableView.register(UINib(nibName: "StudentListViewCell", bundle: .main), forCellReuseIdentifier: "studentlist")
        studentTableView.reloadData()
    }
    
    func fetchStudentRecords(){
        students = studentDataModel.fetchDataObjec()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension fetchStudentController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var teachersName = [String]()
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentlist", for: indexPath) as! StudentListViewCell
        
        let student = students[indexPath.row]

        if let teachers = student.teacher as? Set<Teacher> {
            for teacher in teachers {
                let fetchedTeacherName =  "\(teacher.firstname ?? "") \(teacher.lastname ?? "")"
                teachersName.append(fetchedTeacherName)
            }
        }
            
        cell.setCellData(studentName: student.name, studentAge: Int(student.age), studentId: Int(student.id), studentCourse: student.course, studentTeacherName: "\(teachersName.joined(separator: ", "))")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStudent = students[indexPath.row]
        let editProfile = EditProfileController()
        editProfile.students = selectedStudent
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
}
