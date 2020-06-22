//
//  PageLinks.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation

// MARK: - Next
class Next: Codable {
    var href: String

    init(href: String) {
        self.href = href
    }
}

// MARK: - WelcomeLinks
class Links: Codable {
    var linksSelf, next: Next

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case next
    }

    init(linksSelf: Next, next: Next) {
        self.linksSelf = linksSelf
        self.next = next
    }
}

// MARK: - Page
class Page: Codable {
    var size, totalElements, totalPages, number: Int

    init(size: Int, totalElements: Int, totalPages: Int, number: Int) {
        self.size = size
        self.totalElements = totalElements
        self.totalPages = totalPages
        self.number = number
    }
}
