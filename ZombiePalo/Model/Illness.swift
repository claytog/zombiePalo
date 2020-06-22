//
//  Illness.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation
import GRDB

// MARK: - Illness
class Illness: Codable {
    var name: String
    var id: Int

    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}

extension Illness: FetchableRecord, PersistableRecord{

    class func insert(illness: Illness, completion : @escaping (Bool)->()){

        do{
            
            try DBManager.shared.dbMethod.write { db in
                try db.execute(sql: "REPLACE INTO illness VALUES (?,?)",
                               arguments: [illness.id,
                                           illness.name
                                        ]
                                )
            }
        }catch{
            print(error.localizedDescription)
        }
        completion(true)
    }
    
    class func get(id: Int)->Illness?{
        var returnIllness: Illness?
        do{
            try _ = DBManager.shared.dbMethod.read { db in
                
                returnIllness = try Illness.fetchOne(db,sql: "SELECT * FROM illness WHERE id = ?",
                                                        arguments: [id])
               
            }
        }catch{
            print(error.localizedDescription)
        }
        
        return returnIllness
    }
    
    class func getAll()->[Illness]{
        var returnIllness: [Illness] = []
        do{
            try _ = DBManager.shared.dbMethod.read { db in
                
                returnIllness = try Illness.fetchAll(db,sql: "SELECT * FROM illness",
                                                        arguments: [])
               
            }
        }catch{
            print(error.localizedDescription)
        }
        
        return returnIllness
    }
    
}
