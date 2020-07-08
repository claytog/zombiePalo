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

enum DirectoryAPI: String {
    case hospital = "hospitals"
    case illness = "illnesses"
    case severity = "severity"
}

class ZombieAPI {
    
    static let shared = ZombieAPI()
    
    let baseURI = "http://dmmw-api.australiaeast.cloudapp.azure.com:8080/"
 
    func fetchHospitals(limit: Int, page: Int, completion: @escaping (ZombieHospitalList?) -> ()) {
        
        let directoryName = DirectoryAPI.hospital.rawValue
        
        let urlString:String = "\(baseURI)\(directoryName)?limit=\(String(limit))&page=\(String(page))"
            
        print(urlString)
        
        guard let url = URL(string: urlString) else {
          completion(nil)
          return
        }

        Alamofire.request(url, method: .get, encoding: URLEncoding.default).validate().response { response in

            var parseData:Data?
            
            if let error = response.error {
                parseData = Util.readJSON(fileName: directoryName)
                print (error.localizedDescription)
            }else{
                parseData = response.data!
            }
            
            if let data = parseData {
                
                let hospitalTuple: (ZombieHospitalList?, String?) = ParseJSON.parseObject(jsonData: data)
                
                if let hospitalList = hospitalTuple.0 {
                    for hospital in hospitalList.list.hospitals {
                        Hospital.insert(hospital: hospital, completion: {success  in
                        })
                    }
                    
                    completion(hospitalList)
                }else{
                    if let errMsg = hospitalTuple.1 {
                        print (errMsg)
                    }
                    completion(nil)
                }

            }
        }
        
    }
    
    func fetchIllnesses(completion: @escaping (IllnessList?) -> ()) {
            
        let directoryName = DirectoryAPI.illness.rawValue
        
        let urlString:String = baseURI + directoryName
        
        guard let url = URL(string: urlString) else {
          completion(nil)
          return
        }
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default).validate().response { response in
            
            var parseData:Data?
            
            if let error = response.error {
                parseData = Util.readJSON(fileName: directoryName)
                print (error.localizedDescription)
            }else{
                parseData = response.data!
            }
            
            if let data = parseData {
            
                let illnessTuple: (ZombieIllnessList?, String?) = ParseJSON.parseObject(jsonData: data)
            
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
    
    }
    
    func fetchSeverity(completion: @escaping (SeverityList?) -> ()) {
        
        let directoryName = DirectoryAPI.severity.rawValue
        
        if let jsonData =  Util.readJSON(fileName: directoryName) {
            
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
