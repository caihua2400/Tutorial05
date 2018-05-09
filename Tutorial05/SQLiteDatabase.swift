//
//  SQLiteDatabase.swift
//  Tutorial05
//
//  Created by Hua Cai on 9/5/18.
//  Copyright © 2018 Hua Cai. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabase{
    private var db: OpaquePointer?
    init(databaseName dbName:String){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                   appropriateFor: nil, create: false).appendingPathComponent("\(dbName).sqlite")
        //try and open the file path as a database
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK
        {
            print("Successfully opened connection to database at \(fileURL.path)")
        }
        else
        {
            print("Unable to open database at \(fileURL.path)")
            printCurrentSQLErrorMessage(db)
        }
    }
    deinit {
        sqlite3_close(db)
    }
    func printCurrentSQLErrorMessage(_ db: OpaquePointer?)
    {
        let errorMessage = String.init(cString: sqlite3_errmsg(db))
        print("Error:\(errorMessage)")
    }
    func createMovieTable()
    {
        let createTableQuery = """
CREATE TABLE Movie (
ID INTEGER PRIMARY KEY NOT NULL,
Name CHAR(255),
Year INTEGER,
Director CHAR(255)
);
"""
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK
        {
            
        }
        else
        {
            print("CREATE TABLE statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        
        //execute the statement
        if sqlite3_step(createTableStatement) == SQLITE_DONE
        {
            print("Movie table created.")
        }
        else
        {
            print("Movie table could not be created.")
            printCurrentSQLErrorMessage(db)
        }
        
        sqlite3_finalize(createTableStatement)
        
        
    }
    func insert(movie:Movie)
    {
        let insertStatementQuery =
        "INSERT INTO Movie (ID, Name, Year, Director) VALUES (?, ?, ?, ?);"
        //prepare the statement
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementQuery, -1, &insertStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insertStatement, 1, movie.ID)
            sqlite3_bind_text(insertStatement, 2, movie.name, -1, nil)
            sqlite3_bind_int(insertStatement, 3, movie.year)
            sqlite3_bind_text(insertStatement, 4, movie.director, -1, nil)
        }
        else
        {
            print("INSERT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        if sqlite3_step(insertStatement) == SQLITE_DONE
        {
            print("Successfully inserted row.")
        }
        else
        {
            print("Could not insert row.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(insertStatement)
        
    }
    func selectAllMovies() -> [Movie]
    {
        var result = [Movie]()
        let selectStatementQuery = "SELECT id,name,year,director FROM Movie"
        //prepare the statement
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, selectStatementQuery, -1, &selectStatement, nil) == SQLITE_OK
        {
            //iterate over the result
            while sqlite3_step(selectStatement) == SQLITE_ROW
            {
                //create a movie object from each result
                let movie = Movie(
                    ID: sqlite3_column_int(selectStatement, 0),
                    name: String(cString:sqlite3_column_text(selectStatement, 1)),
                    year: sqlite3_column_int(selectStatement, 2),
                    director: String(cString:sqlite3_column_text(selectStatement, 3))
                )
                
                //add it to the result array
                result += [movie]
            }
        }
        else
        {
            print("SELECT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(selectStatement)
        return result
        
    }
    func selectMovieBy(id:Int32) -> Movie?
    {
        let selectStatementQuery = "SELECT id,name,year,director FROM Movie WHERE id=? "
        var movie=Movie(ID:0,name: "",year:1985,director:"")
        //prepare the statement
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, selectStatementQuery, -1, &selectStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(selectStatement,1,id)
            if sqlite3_step(selectStatement) == SQLITE_ROW{
                let result=Movie(
                    ID: id,
                    name: String(cString:sqlite3_column_text(selectStatement, 1)),
                    year: sqlite3_column_int(selectStatement, 2),
                    director: String(cString:sqlite3_column_text(selectStatement, 3))
                )
                movie=result
              
            }
        }
        else
        {
            print("SELECT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(selectStatement)
        return movie
    }
    func update(movie:Movie)
    {
        let updateStatementQuery="UPDATE Movie SET name=? , year=?, director=? WHERE id=? "
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementQuery, -1, &updateStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(updateStatement, 4, movie.ID)
            sqlite3_bind_text(updateStatement, 1, movie.name, -1, nil)
            sqlite3_bind_int(updateStatement, 2, movie.year)
            sqlite3_bind_text(updateStatement, 3, movie.director, -1, nil)
        }
        else
        {
            print("INSERT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        if sqlite3_step(updateStatement) == SQLITE_DONE
        {
            print("Successfully inserted row.")
        }
        else
        {
            print("Could not insert row.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(updateStatement)
    }
}
