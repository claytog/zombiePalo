//
//  PasrseJSON.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation

class ParseJSON {
   
    class func parseObject<T: Codable>(jsonData: Data) -> (T?, String?){
        
        if let utf8Text = String(data: jsonData, encoding: .utf8) {
            print("\(T.self ) data: \(utf8Text)")
        }
        
        var returnTuple: (T?, String?) = (nil,nil)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let obj: T
        
        var errMsg: String?
        
        do{
            
            obj = try decoder.decode(T.self, from: jsonData)
            returnTuple.0 = obj
            
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            print(context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Decoding Error: \(context.debugDescription)\n\( context.codingPath)"
                
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Key '\(key)' not found: \(context.debugDescription)\n\( context.codingPath)"

        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Value '\(value)' not found: \(context.debugDescription)\n\( context.codingPath)"

        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            errMsg = "Type '\(type)' mismatch:\(context.debugDescription)\n\( context.codingPath)"
        } catch {
            print("error: ", error)
            errMsg = "error: \(error.localizedDescription)"
        }
        returnTuple.1 = errMsg

        return returnTuple
    }
    
    
    
    
}

