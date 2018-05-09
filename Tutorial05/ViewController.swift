//
//  ViewController.swift
//  Tutorial05
//
//  Created by Hua Cai on 9/5/18.
//  Copyright © 2018 Hua Cai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var database:SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        database.createMovieTable()
        database.insert(movie:Movie(ID: 0, name:"Lord of the Rings", year:2003,director: "PeterJackson"))
        database.insert(movie:Movie(ID: 1, name:"The Matrix", year:1999,director: "Lana Miroski"))
        print(database.selectAllMovies())
        print(database.selectMovieBy(id: 1))
        database.update(movie:Movie(ID:0, name:"Lord of the Rings: Return of the King",
                                    year:2003, director:"Peter Jackson"))
        print(database.selectMovieBy(id:0) ?? "Movie not found")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

