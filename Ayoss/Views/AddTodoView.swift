//
//  AddTodoView.swift
//  Ayoss
//
//  Created by 김이예은 on 5/17/25.
//

import SwiftUI
import SwiftData

struct AddTodoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var startDate = Date()
    @State private var finishDate = Date()
    @State private var notiTime: Int? = nil
    @State private var isPeriod: Bool = true //true: 기간 할 일, false: 오늘 할 일
    @State private var isNotiOn: Bool = false
    
    private var todoManager: TodoManager
    
    init(modelContext: ModelContext) {
        self.todoManager = TodoManager(modelContext: modelContext)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("할 일 종류") {
                    Picker("종류", selection: $isPeriod) {
                        Text("기간 할 일").tag(true)
                        Text("오늘 할 일").tag(false)
                    }
                    .pickerStyle(.segmented)
                }
                Section("할 일 정보") {
                    TextField("제목", text: $title)
                    if isPeriod {
                        DatePicker("시작 날짜",
                                 selection: $startDate,
                                 displayedComponents: [.date, .hourAndMinute])
                        DatePicker("종료 날짜",
                                 selection: $finishDate,
                                 displayedComponents: [.date, .hourAndMinute])
                    } else {
                        HStack {
                            Text("날짜")
                            Spacer()
                            Text(dateString(Date()))
                                .foregroundColor(.gray)
                        }
                        DatePicker("시작 시간",
                                 selection: $startDate,
                                 displayedComponents: [.hourAndMinute])
                        HStack {
                            Text("종료 시간")
                            Spacer()
                            Text("23:59")
                                .foregroundColor(.gray)
                        }
                    }
                }
                Section("알림 설정") {
                    Toggle("알림 사용", isOn: $isNotiOn)
                    Picker("알림 시간", selection: Binding(get: { notiTime ?? 0 }, set: { notiTime = $0 })) {
                        ForEach(0..<60) { min in
                            Text("\(min)분 전").tag(min)
                        }
                    }
                    .disabled(!isNotiOn)
                }
            }
            .navigationTitle("새로운 할 일")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        saveTodo()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveTodo() {
        let now = Date()
        let today = Calendar.current.startOfDay(for: now)
        let finish: Date
        if isPeriod {
            finish = finishDate
        } else {
            // 오늘 할 일: 시작 날짜는 생성하는 시점(수정가능), 종료는 오늘 23:59으로 설정(수정불가)
            let start = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: startDate), minute: Calendar.current.component(.minute, from: startDate), second: 0, of: today) ?? now
            startDate = start
            finish = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: today) ?? now
        }
        todoManager.createTodo(
            title: title,
            startDate: startDate,
            finishDate: finish,
            status: false,
            notiTime: isNotiOn ? notiTime : nil
        )
        dismiss()
    }
    
    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}

#Preview {
    AddTodoView(modelContext: try! ModelContainer(for: Todo.self).mainContext)
}
