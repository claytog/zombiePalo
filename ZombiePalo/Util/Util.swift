//
//  Util.swift
//  Copyright © 2020 Clayton GIlbbert. All rights reserved.
//

import Foundation
import UIKit


class Util {
    
    static let shared: Util = Util()
    
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    /*
        shows activity indicator on the given view
    */
    func showActivityIndicator(_ view: UIViewController) {
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.center = view.view.center
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2, y: 2)
        actInd.transform = transform
        actInd.hidesWhenStopped = true
        actInd.style = UIActivityIndicatorView.Style.medium
        view.view.addSubview(actInd)
        actInd.startAnimating()

    }
    
    func hideActivityIndicator(){
        actInd.stopAnimating()
    }
    
    /*
     format date string in ISO format to medium date format
     */
    func formatStringDateMedium(dateString: String! )-> String!{
    
        let DATE_FORMAT_ISO = "yyyy-MM-dd"
        
        if dateString == nil {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = DATE_FORMAT_ISO
    
        let DATE_FORMAT_MEDIUM = "dd MMM yyyy"
        
        if let date = dateFormatter.date(from: dateString) {
        
            let returnDateformat = DateFormatter()
            returnDateformat.dateFormat = DATE_FORMAT_MEDIUM
            let returnDate = returnDateformat.string(from: date)
            return returnDate
        }else{
            return dateString
        }
 
    }
    
    func displayHourMin (minutes : Int ) -> String {
        
        let hrMin = minutesToHoursMinutes (minutes : minutes)
        
        let hours = hrMin.hours > 0 ? String(hrMin.hours) + " hr" : ""
        
        let mins = hrMin.leftMinutes > 0 ? String(hrMin.leftMinutes) + " min" : ""
        
        if hours != "" && mins != "" {
            return hours + ", " + mins
        }else if hours == "" && mins == "" {
            return "0 min"
        }else {
            return hours + mins
        }
        
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    class func readJSON(fileName: String) -> Data!{
        
        var jsonData: Data? = nil
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                // do stuff
            } catch {
                // handle error
            }
        }
        return jsonData
    }
    
    enum DistanceUnit: String {
        case km = "km"
        case m = "m"
    }
    /// Return the string representation of distance in metres as a Double.
    class func distanceToString(_ distance: Double!) -> String {
        let distanceInKm =  Double(round(distance)/1000)
        var unit: DistanceUnit = .km
        var distanceString = String(distanceInKm)
        switch distanceInKm {
        case 0..<1: // less than 1km show m
            distanceString = String(Int(round(distanceInKm * 1000)))
            unit = .m
        case 1..<10: // between 1 and 10km show 1 decimal place
            distanceString = String(format: "%.1f", distanceInKm)
        case 10... : // 10 and above show no decimal place
            distanceString = String(Int(round(distanceInKm)))
        default:
            distanceString = unit.rawValue
        }
        return distanceString + " " + unit.rawValue
    }
}
