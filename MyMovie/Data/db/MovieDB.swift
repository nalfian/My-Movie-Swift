//
//  MovieDB.swift
//  MyMovie
//
//  Created by Unknown on 30/01/20.
//  Copyright © 2020 Nalfian. All rights reserved.
//

import Foundation
import SQLite3

class MovieDB {
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    let dbPath = "myDb.sqlite"
    var db: OpaquePointer?
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Succesfully opened connection")
            return db
        } else {
            print("error opening database")
            return nil
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS movie(id INTEGER PRIMARY KEY, title TEXT, desc TEXT, image TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("movie table created")
            } else {
                print("movie table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(movie: Movie) {
        let movies = reads()
        for m in movies {
            if movie.id == m.id {
                print("return insert")
                return
            }
        }
        
        let insertStatementString = "INSERT INTO movie(id, title, desc, image) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(movie.id))
            sqlite3_bind_text(insertStatement, 2, (movie.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (movie.overview as NSString).utf8String, -1, nil)
            if let poster = movie.posterPath {
                sqlite3_bind_text(insertStatement, 4, (poster as NSString).utf8String, -1, nil)
            }
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("succes")
            } else {
                print("failure")
            }
        } else {
            print("not prepare insert")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func isFavorite(id: Int) -> Bool {
        let movies = reads()
        for m in movies {
            if m.id == id {
                return true
            }
        }
        return false
    }
    
    func reads() -> [Movie] {
        let queryStatementString = "SELECT * FROM movie;"
        var queryStatement: OpaquePointer? = nil
        var movies: [Movie] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            print("query Result:")
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let desc = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let image = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                movies.append(Movie(id: Int(id), title: title, desc: desc, image: image))
                print("\(id) | \(title)")
            }
        } else {
            print("Select not prepared")
        }
        sqlite3_finalize(queryStatement)
        return movies
    }
    
    func delete(id: Int) {
        let deleteStatementString = "DELETE FROM movie WHERE ID = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("success delete")
            } else {
                print("failure")
            }
        } else {
            print("delete not prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
