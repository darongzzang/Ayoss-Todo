//
//  TodoManager.swift
//  Ayoss
//
//  Created by 김이예은 on 5/17/25.
//

import Foundation
import SwiftData

class TodoManager {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    //데이서 생성
    func createTodo(title: String, startDate: Date, finishDate: Date, status: Bool = false, notiTime: Int? = nil) {
        let todo = Todo(title: title, startDate: startDate, finishData: finishDate, status: status, notiTime: notiTime)
        modelContext.insert(todo)
        saveContext()
    }
    
    //데이터 조회
    func fetchTodos() -> [Todo] {
        let descriptor = FetchDescriptor<Todo>(sortBy: [SortDescriptor(\.startDate)])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching todos: \(error)")
            return []
        }
    }
    
    //날짜로 조회
    func fetchTodosByDate(_ date: Date) -> [Todo] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<Todo> { todo in
            todo.startDate >= startOfDay && todo.startDate < endOfDay
        }
        
        let descriptor = FetchDescriptor<Todo>(predicate: predicate, sortBy: [SortDescriptor(\.startDate)])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching todos by date: \(error)")
            return []
        }
    }
    
    //데이터 수정
    func updateTodo(_ todo: Todo, title: String? = nil, startDate: Date? = nil, finishDate: Date? = nil, status: Bool? = nil, notiTime: Int? = nil) {
        if let title = title {
            todo.title = title
        }
        if let startDate = startDate {
            todo.startDate = startDate
        }
        if let finishDate = finishDate {
            todo.finishData = finishDate
        }
        if let status = status {
            todo.status = status
        }
        if let notiTime = notiTime {
            todo.notiTime = notiTime
        }
        saveContext()
    }
    
    //데이터 삭제
    func deleteTodo(_ todo: Todo) {
        modelContext.delete(todo)
        saveContext()
    }
    
    // 데이터 저장
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
