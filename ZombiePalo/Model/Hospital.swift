//
//  Hospital.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation
import GRDB

// MARK: - Hospital
class Hospital: Codable {
    var id: Int
    var name: String
    var waitingList: [WaitingList]?
    var location: Location?

    // db columns
    var lat: Double?
    var lng: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case waitingList
        case location
        case lat
        case lng
    }

    init(id: Int, name: String, waitingList: [WaitingList], location: Location) {
        self.id = id
        self.name = name
        self.waitingList = waitingList
        self.location = location
    }
}
extension Hospital: FetchableRecord, PersistableRecord{

    class func insert(hospital: Hospital, completion : @escaping (Bool)->()){

        do{
            try DBManager.shared.dbMethod.write { db in
                try db.execute(sql: "REPLACE INTO hospital VALUES (?,?,?,?)",
                               arguments: [hospital.id,
                                           hospital.name,
                                           hospital.location?.lat,
                                           hospital.location?.lng
                                        ]
                                )
            }
        }catch{
            print(error.localizedDescription)
        }
        
        if let waitingList = hospital.waitingList {
            for wait in waitingList {
                wait.hospitalId = hospital.id
                WaitingList.insert(waitingList: wait, completion: {success in
                    
                })
            }
        }
        completion(true)
    }
    
    class func get(id: Int)->Hospital?{
        var returnHospital: Hospital?
        do{
            try _ = DBManager.shared.dbMethod.read { db in
                
                returnHospital = try Hospital.fetchOne(db,sql: "SELECT * FROM Hospital WHERE id = ?",
                                                        arguments: [id])
               
            }
        }catch{
            print(error.localizedDescription)
        }
        
        return returnHospital
    }
    
    class func getAll(severity:Severity, completion : @escaping ([Hospital])->()){
        var returnHospital: [Hospital] = []
        do{
            try _ = DBManager.shared.dbMethod.read { db in
                
                returnHospital = try Hospital.fetchAll(db,sql: "SELECT * FROM Hospital",
                                                        arguments: [])
            }
            
            returnHospital.sort(by: {$0.getWaitTime(severity: severity)! < $1.getWaitTime(severity: severity)!})
            
        }catch{
            print(error.localizedDescription)
        }

        completion (returnHospital) 
    }
    
    func getWaitTime(severity:Severity)->Int?{
        var returnWaitTime: Int?
        do{
            try _ = DBManager.shared.dbMethod.read { db in
                
                returnWaitTime = try Int.fetchOne(db,sql: "SELECT waitTime FROM waitingList WHERE hospitalId = ? AND levelOfPain = ?",
                                                       arguments: [self.id,
                                                                   severity.levelOfPain
                ])
               
            }
        }catch{
            print(error.localizedDescription)
        }
        
        return returnWaitTime
    }
    
}
