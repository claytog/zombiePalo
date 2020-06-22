//
//  Connectivity.swift
//  ZombiePalo
//
//  Created by Clayton on 22/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
