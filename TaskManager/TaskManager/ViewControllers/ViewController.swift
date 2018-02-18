//
//  ViewController.swift
//  TaskManager
//
//  Created by Divya Basappa on 2/13/18.
//  Copyright © 2018 Divya Basappa. All rights reserved.
//

import UIKit

enum SelectedSegment: Int {
    case pending = 0
    case complete = 1
}

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    private var pending = [Task]()
    private var completed = [Task]()
    private var persistence: PersistenceManager!
    private var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persistence = PersistenceManager()
        persistence.createTables()
        setupTaskTableViewCell()
    }
    
    private func setupTaskTableViewCell() {
        let nib = UINib(nibName: "TaskCellTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "CustomCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }

    @objc func addTask() {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "taskViewStoryBoard") as? CreateTaskViewController
        let navController = UINavigationController(rootViewController: newViewController!)
        present(navController, animated: true, completion: nil)
    }

    @IBAction func switchCustomTableViewAction(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
        tableview.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeData()
    }
    
    private func initializeData() {
        pending.removeAll()
        completed.removeAll()
        let allTasks = persistence.fetchAlltasks()
        
        for task in allTasks {
            if task.status == true {
                completed.append(task)
            } else {
                pending.append(task)
            }
        }
        
        tableview.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == SelectedSegment.complete.rawValue {
            return completed.count
        }
        return pending.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedIndex == SelectedSegment.complete.rawValue {
            let cell = tableview.dequeueReusableCell(withIdentifier: "CustomCell") as? TaskCellTableViewCell
            if let taskCell = cell {
                let taskName = completed[indexPath.row].name
                taskCell.customInit(name: taskName)
                return taskCell
            }
        } else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "CustomCell") as? TaskCellTableViewCell
            if let taskCell = cell {
                let taskName = pending[indexPath.row].name
                taskCell.customInit(name: taskName)
                return taskCell
            }
        }
        
        return UITableViewCell()
    }
}
