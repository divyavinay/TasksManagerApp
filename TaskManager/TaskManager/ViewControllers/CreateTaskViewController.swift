//
//  CreateTaskViewController.swift
//  TaskManager
//
//  Created by Divya Basappa on 2/14/18.
//  Copyright © 2018 Divya Basappa. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
    
    private var cellsAdded = [keywordTableViewCell]()
    private var keyWordsCellData = [keywordTableViewCell]()
    private var taskName: String?
    private var descriptionName: String?
    private var filePath: String?
    private var persistence: PersistenceManager!
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persistence = PersistenceManager()
        setupCells()
    }

    private func setupCells() {
        let nibName = UINib(nibName: "NameCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "taskNameTableViewCell")
        
        let nibDes  = UINib(nibName: "DescriptionTableViewCell", bundle: nil)
        tableview.register(nibDes, forCellReuseIdentifier: "descriptionTableViewCell")
        
        let nibFile = UINib(nibName: "fileTableViewCell", bundle: nil)
        tableview.register(nibFile, forCellReuseIdentifier: "fileTableViewCell")
        
        let nibKeywords = UINib(nibName: "keywordTableViewCell", bundle: nil)
        tableview.register(nibKeywords, forCellReuseIdentifier: "keywordsTableCell")
        
        let nibAddKeywords = UINib(nibName: "AddKeyWordsCell", bundle: nil)
        tableview.register(nibAddKeywords, forCellReuseIdentifier: "AddKeyWordsCell")
    }
    
    @IBAction func addKeyword(_ sender: UIButton) {
        let cell = keywordTableViewCell()
        cellsAdded.append(cell)
        tableview.reloadData()
    }
    
    @IBAction func saveTasks(_ sender: UIButton) {
        var keywords = String()
        for cell in Set(keyWordsCellData) {
            if let word = cell.keywordTextFeild.text {
                keywords = keywords + "," + word
            }
        }
        
        let task = Task(id: UUID().uuidString,
                        name: taskName ?? "",
                        description: descriptionName ?? "",
                        filePath: filePath ?? "",
                        keywords: keywords,
                        status: false)
        persistence.insertTask(task: task)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTaskEntry(_ sender: UIButton) {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "displayTasksScreen") as? ViewController
        let navController = UINavigationController(rootViewController: newViewController!)
        present(navController, animated: true, completion: nil)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension CreateTaskViewController: UITableViewDataSource, UITableViewDelegate, UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
   
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        filePath = "\(url)"
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            tableview.setEditing(true, animated: true)
        }
        else {
            tableview.setEditing(false, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else if section == 1 {
            return cellsAdded.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableview.dequeueReusableCell(withIdentifier: "taskNameTableViewCell") as? NameCell
                if let taskNameCell = cell {
                    taskName = taskNameCell.taskNameTextFeild?.text
                    return taskNameCell
                }
            } else if indexPath.row == 1 {
                let cell = tableview.dequeueReusableCell(withIdentifier: "descriptionTableViewCell") as? DescriptionTableViewCell
                if let descriptionNameCell = cell {
                    descriptionName = descriptionNameCell.descriptionTextFeild?.text
                    return descriptionNameCell
                }
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "fileTableViewCell") as? fileTableViewCell
                if let fileNameCell = cell {
                    fileNameCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                    return fileNameCell
                }
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "keywordsTableCell") as? keywordTableViewCell
            if let keywordsCell = cell {
                 keyWordsCellData.append(keywordsCell)
                return keywordsCell
            }
        } else if indexPath.section == 2 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "AddKeyWordsCell", for: indexPath) as? AddKeyWordsCell
            if let addKeywordsCell = cell {
                return addKeywordsCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let importMenu = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true, completion: nil)
        }
    }
    
}
