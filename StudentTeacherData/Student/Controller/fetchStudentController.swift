//
//  fetchStudentController.swift
//  StudentTeacherData
//
//  Created by Vishu on 29/01/24.
//

import UIKit

protocol StudentSelectionDelegate: AnyObject {
    func didSelectStudent(_ student: Student )
}

class fetchStudentController: UIViewController {
    
    @IBOutlet weak var studentTableView: UITableView!
    
    // call StudentData Model
    let studentDataModel = StudentData()
    
    // empty student-Array object
    var students : [Student] = []
    
    // protocol-delegate
    weak var delegate: StudentSelectionDelegate?
    
    // Students Object for selecting Teachers
    var teachers : Teacher?
    
    // variable to enable button in Cells
    var is_FromNavigation:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modifyNavigationBar()
        modifyTableView()
        fetchStudentRecords()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTableView()
        studentTableView.reloadData()
    }
    
    func modifyNavigationBar(){
        self.navigationItem.title = "Student's List"
        let doneButton = UIBarButtonItem(systemItem: .done)
        doneButton.target = self
        doneButton.action = #selector(doneAction)
        if is_FromNavigation == true {
            self.navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    @objc func doneAction(){
        var studentsArr:[Student]?
        
        if let student = teachers?.student as? Set<Student> {
            studentsArr = Array(student)
        }

        for student in students {
            if student.isSelected == true {
                studentsArr?.append(student)
                delegate?.didSelectStudent(student)
            }
            if student.isSelected == true {
                student.isSelected = false
            }
        }
        if studentsArr != nil {
            teachers?.student = NSSet(array: studentsArr!)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            if let context = appDelegate?.persistentContainer.viewContext {
                do {
                    try context.save()
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func modifyTableView(){
        studentTableView.backgroundColor = UIColor.systemGroupedBackground
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentlist", for: indexPath) as! StudentListViewCell
        
        let student = students[indexPath.row]

        if is_FromNavigation == true {
            cell.setCellData(student: student, isCheckMarkHidden: false)
        } else {
            cell.setCellData(student: student)
        }
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
