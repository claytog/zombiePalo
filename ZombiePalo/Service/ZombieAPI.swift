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
            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                         print("Films data: \(utf8Text)")
//            }

            ParseJSON.parseHospital (jsonData: response.data!, completion: { list in
                
                var returnHospitalList: HospitalList?
                
                if let hospitalList = list?.list.hospitals {
                    returnHospitalList = list?.list
                    
                    for hospital in hospitalList { // insert film into local database
                        Hospital.insert(hospital: hospital, completion: {success  in
                            
                        })
                            
                    }
                }
                completion(returnHospitalList)
            })
        }
    }
    
    func fetchIllnesses(completion: @escaping (IllnessList?) -> ()) {
            
        let urlString:String = baseURI + "illnesses"
        
        Alamofire.request(urlString, method: .get, encoding: URLEncoding.default).validate().response { response in
            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                         print("Character data: \(utf8Text)")
//            }

            ParseJSON.parseIllness(jsonData: response.data!, completion: { list in
                    
                var returnIllnessList: IllnessList?
                
                if (list?.list.illnesses) != nil {
                    returnIllnessList = list?.list
                    
                    if let illnesses = returnIllnessList?.illnesses {
                        for illness in illnesses { // insert film into local database
                            Illness.insert(illness: illness.illness, completion: {success  in

                            })
                        }
                    }
                }
                completion(returnIllnessList)
            })
            
        }
    
    }
    
    func fetchSeverity(completion: @escaping (SeverityList?) -> ()) {
        
        var returnSeverityList: SeverityList?
        
        
        if let severityList = ParseJSON.parseSeverity() {
            returnSeverityList = severityList
            for severity in severityList.severity {
                Severity.insert(severity: severity, completion: { success in
                })
            }
        }
        completion(returnSeverityList)
    }
}
