//
//  SQL.swift
//  TableViewSections
//
//  Created by Divya Basappa on 2/18/18.
//  Copyright © 2018 Vinay Ganesh. All rights reserved.
//

import Foundation
import SQLite


class SQLiteConnection {
    static let shared = SQLiteConnection()
    
    var dbConnection: Connection? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        do {
            return try Connection("\(path)/tasks.sqlite3")
        } catch {
           print(error.localizedDescription)
            return nil
        }
    }
}
