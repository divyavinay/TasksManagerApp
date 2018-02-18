//
//  PersistenceManager.swift
//  TableViewSections
//
//  Created by Divya Basappa on 2/18/18.
//  Copyright © 2018 Vinay Ganesh. All rights reserved.
//

import Foundation
import SQLite



class PersistenceManager {
    
    private let tasksTable = Table("tasks")
    private let taskId = Expression<String>("id")
    private let name = Expression<String>("name")
    private let description = Expression<String>("description")
    private let filePath = Expression<String>("filepath")
    private let keywords = Expression<String>("keywords")
    private let status = Expression<Bool>("status")
    
    var connection: Connection? {
        guard let dbConnection = SQLiteConnection.shared.dbConnection else {
            return nil
        }
        
        return dbConnection
    }
    
    func createTasksTable(connection: Connection) {
        do {
            try connection.run(tasksTable.create(ifNotExists: true) { table in
                table.column(taskId, primaryKey: true)
                table.column(name)
                table.column(description)
                table.column(filePath)
                table.column(keywords)
                table.column(status)
            })
        } catch {
            print("Unable to create table \(error)")
        }
    }
    
    func createTables() {
        guard let dbConnection = connection else {
            return
        }
        
        createTasksTable(connection: dbConnection)
    }
    
    func insertTask(task: Task) {
        do {
            let insertATask = tasksTable.insert(taskId <- task.id,
                                                name <- task.name,
                                                description <- task.description,
                                                filePath <- task.filePath,
                                                keywords <- task.keywords,
                                                status <- task.status)
            let tasksID = try connection?.run(insertATask)
            print("task:\(tasksID ?? 0) inserted")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAlltasks() -> [Task] {
        var tasks = [Task]()
        
        do {
            guard let db = connection else {
                return []
            }
            
            for task in try db.prepare(tasksTable) {
                let t = Task(id: task[taskId], name: task[name], description: task[description], filePath: task[filePath], keywords: task[keywords], status: task[status])
                tasks.append(t)
            }
        } catch {
            print(error.localizedDescription)
        }
        return tasks
    }
}
