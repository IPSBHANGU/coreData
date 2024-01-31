//
//  fetchTeacherController.swift
//  StudentTeacherData
//
//  Created by Vishu on 30/01/24.
//

import UIKit

protocol TeacherSelectionDelegate: AnyObject {
    func didSelectTeacher(_ teacher: Teacher )
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

        modifyNavigationBar()
        setTableView()
        fetchTeacherRecords()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        teacherTableView.reloadData()
    }
    
    func modifyNavigationBar(){
        self.navigationItem.title = "Teacher's List"
        let doneButton = UIBarButtonItem(systemItem: .done)
        doneButton.target = self
        doneButton.action = #selector(doneAction)
        if is_FromNavigation == true {
            self.navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    @objc func doneAction(){
        var teachersArr:[Teacher]?
        
        if let teacher = students?.teacher as? Set<Teacher> {
            teachersArr = Array(teacher)
        }

        for teacher in teachers {
            if teacher.isSelected == true {
                teachersArr?.append(teacher)
                delegate?.didSelectTeacher(teacher)
            }
            if teacher.isSelected == true {
                teacher.isSelected = false
            }
        }
        if teachersArr != nil {
            students?.teacher = NSSet(array: teachersArr!)
            
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
    
    func setTableView(){
        teacherTableView.delegate = self
        teacherTableView.dataSource = self
        teacherTableView.register(UINib(nibName: "TeacherListViewCell", bundle: .main), forCellReuseIdentifier: "teacherList")
        teacherTableView.reloadData()
    }
    
    func fetchTeacherRecords(){
        teachers = teacherDataModel.fetchDataObjec()
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

extension fetchTeacherController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherList", for: indexPath) as! TeacherListViewCell
        
        let teacher = teachers[indexPath.row]

        if is_FromNavigation == true {
            cell.setCellData(teacher: teacher, isCheckMarkHidden: false)
        } else {
            cell.setCellData(teacher: teacher)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTeacher = teachers[indexPath.row]
        let editProfile = EditTeacherProfileController()
        editProfile.teachers = selectedTeacher
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
}
