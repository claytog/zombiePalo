//
//  HospitalAPI.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation
import Alamofire
import GRDB

class ZombieAPI {
    
    static let shared = ZombieAPI()
    
    let baseURI = "http://dmmw-api.australiaeast.cloudapp.azure.com:8080/"
    
    func fetchHospitals(completion: @escaping (HospitalList?) -> ()) {
        
        let urlString:String = baseURI + "hospitals"
            
        Alamofire.request(urlString, method: .get, encoding: URLEncoding.default).validate().response { response in

            let hospitalTuple: (ZombieHospitalList?, String?) = ParseJSON.parseObject(jsonData: response.data!)
            
            if let hospitalList = hospitalTuple.0 {
                for hospital in hospitalList.list.hospitals {
                    Hospital.insert(hospital: hospital, completion: {success  in
                    })
                }
                completion(hospitalList.list)
            }else{
                if let errMsg = hospitalTuple.1 {
                    print (errMsg)
                }
                completion(nil)
            }
        }
        
    }
    
    func fetchIllnesses(completion: @escaping (IllnessList?) -> ()) {
            
        let urlString:String = baseURI + "illnesses"
        
        Alamofire.request(urlString, method: .get, encoding: URLEncoding.default).validate().response { response in
            
            let illnessTuple: (ZombieIllnessList?, String?) = ParseJSON.parseObject(jsonData: response.data!)
            
            if let illnessList = illnessTuple.0 {
                for illness in illnessList.list.illnesses {
                    Illness.insert(illness: illness.illness, completion: { success in
                    })
                }
                completion(illnessList.list)
            }else{
                if let errMsg = illnessTuple.1 {
                    print (errMsg)
                }
                completion(nil)
            }
        }
    
    }
    
    func fetchSeverity(completion: @escaping (SeverityList?) -> ()) {
        
        if let jsonData =  Util.readJSON(fileName: "severity") {
            
            let severityTuple: (SeverityList?, String?) = ParseJSON.parseObject(jsonData: jsonData as Data)
            
            if let severityList = severityTuple.0 {
                for severity in severityList.severity {
                    Severity.insert(severity: severity, completion: { success in
                    })
                }
                completion(severityList)
            }else{
                if let errMsg = severityTuple.1 {
                    print (errMsg)
                }
                completion(nil)
            }
        }
    }
    
}
