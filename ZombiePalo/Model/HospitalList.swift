//
//  HospitalList.swift
//  zombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation

// MARK: - ZombieHospitalList
class ZombieHospitalList: Codable {
    var list: HospitalList
    var links: Links
    var page: Page

    enum CodingKeys: String, CodingKey {
        case list = "_embedded"
        case links = "_links"
        case page
    }

    init(list: HospitalList, links: Links, page: Page) {
        self.list = list
        self.links = links
        self.page = page
    }
}

// MARK: - HospitalList
class HospitalList: Codable {
    var hospitals: [Hospital]

    init(hospitals: [Hospital]) {
        self.hospitals = hospitals
    }
}
