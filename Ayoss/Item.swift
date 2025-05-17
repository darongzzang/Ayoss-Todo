//
//  Item.swift
//  Ayoss
//
//  Created by 김이예은 on 5/17/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
