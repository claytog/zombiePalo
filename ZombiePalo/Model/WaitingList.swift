//
//  WaitingList.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation

// MARK: - WaitingList
class WaitingList: Codable {
    var hospitalId: Int?
    var levelOfPain: Int
    var patientCount: Int
    var averageProcessTime: Int
    
    init(hospitalId: Int, patientCount: Int, levelOfPain: Int, averageProcessTime: Int) {
        self.hospitalId = hospitalId
        self.patientCount = patientCount
        self.levelOfPain = levelOfPain
        self.averageProcessTime = averageProcessTime
    }
}
extension WaitingList {
    
    var waitTime: Int? {
        
        get {
            return patientCount * averageProcessTime
        }
    }
    
    class func insert(waitingList: WaitingList, completion : @escaping (Bool)->()){

        do{
            
            try DBManager.shared.dbMethod.write { db in
                try db.execute(sql: "REPLACE INTO waitingList VALUES (?,?,?,?,?)",
                               arguments: [waitingList.hospitalId,
                                           waitingList.levelOfPain,
                                           waitingList.patientCount,
                                           waitingList.averageProcessTime,
                                           waitingList.waitTime
                                        ]
                                )
            }
        }catch{
            print(error.localizedDescription)
        }
        completion(true)
    }
    
}

