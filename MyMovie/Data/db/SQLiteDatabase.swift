//
//  SQLiteDatabase.swift
//  MyMovie
//
//  Created by Unknown on 30/01/20.
//  Copyright © 2020 Nalfian. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabase {
    private let dbPointer: OpaquePointer?
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    deinit {
        sqlite3_close(dbPointer)
    }
}


func open(path: String) throws -> SQLiteDatabase {
    var db: OpaquePointer?
    if sqlite3_open(path, &db) == SQLITE_OK {
        return SQLiteDatabase(dbPointer: db)
    }
}
