//
//  fetchTeacherController.swift
//  StudentTeacherData
//
//  Created by Vishu on 30/01/24.
//

import UIKit

protocol TeacherSelectionDelegate: AnyObject {
    func didSelectTeacher(_ teacher: [Teacher] )
}

class fetchTeacherController: UIViewController {

    @IBOutlet weak var teacherTableView: UITableView!
    
    // call TeacherData Model
    let teacherDataModel = TeacherData()
    // empty teacher-Array object
    var teachers : [Teacher] = []
    // protocol-delegate
    weak var delegate: TeacherSelectionDelegate?
    // variable to enable button in Cells
    var is_FromNavigation:Bool = false
    // Students Object for selecting Teachers
    var students : Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        modifyNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTeacherRecords()
    }
    
    func modifyNavigationBar(){
        self.navigationItem.title = "Teacher's List"
        guard is_FromNavigation == true else { return}
        let doneButton = UIBarButtonItem(systemItem: .done)
        doneButton.target = self
        doneButton.action = #selector(doneAction)
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneAction(){
        var teachersArr:[Teacher]?
        teachersArr = teacherDataModel.addSelectedStudents(teachers: teachers, students: students)
        delegate?.didSelectTeacher(teachersArr!)
        navigationController?.popViewController(animated: true)
    }
    
    func setTableView(){
        teacherTableView.delegate = self
        teacherTableView.dataSource = self
        teacherTableView.register(UINib(nibName: "TeacherListViewCell", bundle: .main), forCellReuseIdentifier: "teacherList")
        teacherTableView.backgroundColor = UIColor.systemGroupedBackground
    }
    
    func fetchTeacherRecords(){
        teachers = teacherDataModel.fetchDataObjec()
        teacherTableView.reloadData()
    }
}

extension fetchTeacherController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teacherList", for: indexPath) as? TeacherListViewCell else {
            return UITableViewCell()
        }
        let teacher = teachers[indexPath.row]
        cell.setCellData(teacher: teacher, isCheckMarkHidden: !is_FromNavigation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if is_FromNavigation == false {
            let selectedTeacher = teachers[indexPath.row]
            let editProfile = EditTeacherProfileController()
            editProfile.teachers = selectedTeacher
            self.navigationController?.pushViewController(editProfile, animated: true)
        }
    }
}
