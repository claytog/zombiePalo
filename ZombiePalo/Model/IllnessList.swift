//
//  Illness.swift
//  zombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation

// MARK: - ZombieIllnessList
class ZombieIllnessList: Codable {
    var list: IllnessList
    var links: Links
    var page: Page

    enum CodingKeys: String, CodingKey {
        case list = "_embedded"
        case links = "_links"
        case page
    }

    init(list: IllnessList, links: Links, page: Page) {
        self.list = list
        self.links = links
        self.page = page
    }
}

// MARK: - ZombieIllnessList
class IllnessList: Codable {
    var illnesses: [IllnessElement]

    init(illnesses: [IllnessElement]) {
        self.illnesses = illnesses
    }
}

// MARK: - IllnessElement
class IllnessElement: Codable {
    var illness: Illness
    var links: IllnessLinks

    enum CodingKeys: String, CodingKey {
        case illness
        case links = "_links"
    }

    init(illness: Illness, links: IllnessLinks) {
        self.illness = illness
        self.links = links
    }
}

// MARK: - IllnessLinks
class IllnessLinks: Codable {
    var illnesses: Next
    var linksSelf: Next

    enum CodingKeys: String, CodingKey {
        case illnesses
        case linksSelf = "self"
    }

    init(illnesses: Next, linksSelf: Next) {
        self.illnesses = illnesses
        self.linksSelf = linksSelf
    }
}


