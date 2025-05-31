//
//  HomeView+.swift
//  Ayoss
//
//  Created by 김이예은 on 5/31/25.
//

import SwiftUI


extension HomeView {
    func fetchTodos() {
        todos = todoManager.fetchTodos()
    }
}


extension TodoCardView {
    //TODO: dateString 하나로 모아서 Constants 폴더에 넣기
    func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}
