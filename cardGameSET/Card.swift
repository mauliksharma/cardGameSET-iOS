//
//  Card.swift
//  cardGameSET
//
//  Created by Maulik Sharma on 28/09/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import Foundation

struct Card: Hashable {
    let shape, number, color, shade: Int
    
    let hashValue: Int
    static var hashFactory = -1
    static func getUniqueHash() -> Int {
        hashFactory += 1
        return hashFactory
    }
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
