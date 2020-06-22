//
//  PasrseJSON.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation

class ParseJSON {

    class func parseHospital(jsonData: Data, completion : @escaping (ZombieHospitalList?)->()){

        let decoder = JSONDecoder()
             
        let obj: ZombieHospitalList
        var errMsg = ""
        
        do{
        
            obj = try decoder.decode(ZombieHospitalList.self, from: jsonData)
            
            let resultList = obj.self
            
            print("resultList count: " + String(obj.list.hospitals.count) )

            completion(resultList)
            
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            print(context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Decoding Error: " + context.debugDescription + "\n\( context.codingPath)"
                
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Key '\(key)' not found:" + context.debugDescription + "\n\( context.codingPath)"

        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Value '\(value)' not found:" + context.debugDescription + "\n\( context.codingPath)"

        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Type '\(type)' mismatch:" + context.debugDescription + "\n\( context.codingPath)"
        } catch {
            print("error: ", error)
            errMsg = "error: " + error.localizedDescription
        }
        if errMsg != "" {
            completion(nil)
        }
        
        
    }
    
    class func parseIllness(jsonData: Data, completion : @escaping (ZombieIllnessList?)->()){

        let decoder = JSONDecoder()
             
        let obj: ZombieIllnessList
        var errMsg = ""
        
        do{
        
            obj = try decoder.decode(ZombieIllnessList.self, from: jsonData)
            completion(obj)
            
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            print(context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Decoding Error: " + context.debugDescription + "\n\( context.codingPath)"
                
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Key '\(key)' not found:" + context.debugDescription + "\n\( context.codingPath)"

        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Value '\(value)' not found:" + context.debugDescription + "\n\( context.codingPath)"

        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Type '\(type)' mismatch:" + context.debugDescription + "\n\( context.codingPath)"
        } catch {
            print("error: ", error)
            errMsg = "error: " + error.localizedDescription
        }
        if errMsg != "" {
            completion(nil)
        }
    }
    
    class func parseSeverity() -> SeverityList?{
        var returnList: SeverityList?

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        if let jsonData =  Util.readJSON(fileName: "severity") {

        //        if let utf8Text = String(data: jsonData! as Data, encoding: .utf8) {
        //            print("FORM Data: \(utf8Text)")
        //        }

           do{

            returnList = try decoder.decode(SeverityList.self, from: jsonData as Data)

           } catch let DecodingError.dataCorrupted(context) {
               print(context)
           } catch let DecodingError.keyNotFound(key, context) {
               print("Key '\(key)' not found:", context.debugDescription)
               print("codingPath:", context.codingPath)
           } catch let DecodingError.valueNotFound(value, context) {
               print("Value '\(value)' not found:", context.debugDescription)
               print("codingPath:", context.codingPath)
           } catch let DecodingError.typeMismatch(type, context)  {
               print("Type '\(type)' mismatch:", context.debugDescription)
               print("codingPath:", context.codingPath)
           } catch {
               print("error: ", error)
           }
        }
        return returnList
        }
    
   

    
}

