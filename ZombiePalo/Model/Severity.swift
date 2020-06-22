//
//  Severity.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation
import GRDB

class SeverityList: Codable{
    var severity: [Severity]
}

class Severity: Codable {
    
    var id: Int
    var title: String
    var imageName: String
    var levelOfPain: Int
    
    init(id:Int, title: String, imageName:String, levelOfPain: Int){
        
        self.id = id
        self.title = title
        self.imageName = imageName
        self.levelOfPain = levelOfPain
        
    }
}
extension Severity: FetchableRecord, PersistableRecord{
    static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace
    )
    class func insert(severity: Severity, completion : @escaping (Bool)->()){

        do{
            try DBManager.shared.dbMethod.write { db in
                try severity.insert(db)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    class func get(id: Int)->Severity?{
        var returnSeverity: Severity?
        do{
            try _ = DBManager.shared.dbMethod.read { db in
                
                returnSeverity = try Severity.fetchOne(db,sql: "SELECT * FROM severity WHERE id = ?",
                                                        arguments: [id])
               
            }
        }catch{
            print(error.localizedDescription)
        }
        
        return returnSeverity
    }
    
    class func getAll()->[Severity]{
        var returnSeverity: [Severity] = []
        do{
            try _ = DBManager.shared.dbMethod.read { db in
                
                returnSeverity = try Severity.fetchAll(db)
               
            }
        }catch{
            print(error.localizedDescription)
        }
        
        return returnSeverity
    }
    
}
