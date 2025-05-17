//
//  Item.swift
//  Ayoss
//
//  Created by 김이예은 on 5/17/25.
//

import Foundation
import SwiftData

@Model
class Todo {
    var title: String
    var startDate: Date
    var finishData: Date //(하루만 하는 날이면 startDate와 finishDate는 동일)
    var status: Bool //(false = 안함, true = 완료)
    var notiTime: Int?
    
    init(title: String, startDate: Date, finishData: Date, status: Bool, notiTime: Int? = nil) {
        self.title = title
        self.startDate = startDate
        self.finishData = finishData
        self.status = status
        self.notiTime = notiTime
    }
}
