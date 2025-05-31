//
//  HomeView.swift
//  Ayoss
//
//  Created by 김이예은 on 5/17/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddTodo = false
    @State private var selectedDate = Date()
    @State private var editingTodoID: PersistentIdentifier? = nil
    @State private var editingTitle: String = ""
    @State private var editingStartDate: Date = Date()
    @State private var editingFinishDate: Date = Date()
    @State private var editingNotiTime: Int? = nil
    @State var todos: [Todo] = []
    
    var todoManager: TodoManager { //TodoManager 객체 생성
        TodoManager(modelContext: modelContext)
    }
    
    //날짜 포맷터
    var dateFormatter: DateFormatterConstant {
        let formatter = DateFormatterConstant()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    var periodTodos: [Todo] { //기간 할 일
        todos.filter {
            $0.startDate <= selectedDate && selectedDate <= $0.finishData && !Calendar.current.isDate($0.startDate, inSameDayAs: $0.finishData)
        }
    }
    var todayTodos: [Todo] { //오늘 할 일
        todos.filter {
            Calendar.current.isDate($0.startDate, inSameDayAs: selectedDate) &&
            Calendar.current.isDate($0.finishData, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                //상단 날짜 및+버튼
                HStack {
                    Button {
                        //날짜 선택 액션
                    } label: {
                        Text(dateFormatter.string(from: selectedDate))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .contextMenu {
                        DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                    }
                    Spacer()
                    Button {
                        isShowingAddTodo = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                // 기간 할 일 뷰
                if !periodTodos.isEmpty {
                    TodoCardView(
                        title: "기간 할 일",
                        todos: periodTodos,
                        editingTodoID: $editingTodoID,
                        editingTitle: $editingTitle,
                        editingStartDate: $editingStartDate,
                        editingFinishDate: $editingFinishDate,
                        editingNotiTime: $editingNotiTime,
                        onEdit: { todo in //수정모드 진입
                            editingTodoID = todo.persistentModelID
                            editingTitle = todo.title
                            editingStartDate = todo.startDate
                            editingFinishDate = todo.finishData
                            editingNotiTime = todo.notiTime
                        },
                        onSave: { todo in //저장
                            todoManager.updateTodo(todo, title: editingTitle, startDate: editingStartDate, finishDate: editingFinishDate, notiTime: editingNotiTime)
                            editingTodoID = nil
                            fetchTodos()
                        },
                        onStatusToggle: { todo in //상태 토글 가능
                            todoManager.updateTodo(todo, status: !todo.status)
                            fetchTodos()
                        }
                    )
                    .padding(.horizontal)
                }
                
                // 오늘 할 일 뷰
                if !todayTodos.isEmpty {
                    TodoCardView(
                        title: "오늘 할 일",
                        todos: todayTodos,
                        editingTodoID: $editingTodoID,
                        editingTitle: $editingTitle,
                        editingStartDate: $editingStartDate,
                        editingFinishDate: $editingFinishDate,
                        editingNotiTime: $editingNotiTime,
                        onEdit: { todo in
                            editingTodoID = todo.persistentModelID
                            editingTitle = todo.title
                            editingStartDate = todo.startDate
                            editingFinishDate = todo.finishData
                            editingNotiTime = todo.notiTime
                        },
                        onSave: { todo in
                            todoManager.updateTodo(todo, title: editingTitle, startDate: editingStartDate, finishDate: editingFinishDate, notiTime: editingNotiTime)
                            editingTodoID = nil
                            fetchTodos()
                        },
                        onStatusToggle: { todo in
                            todoManager.updateTodo(todo, status: !todo.status)
                            fetchTodos()
                        }
                    )
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.top)
            .background(Color(.systemGray6))
            .sheet(isPresented: $isShowingAddTodo, onDismiss: fetchTodos) {
                AddTodoView(modelContext: modelContext)
            }
            .onAppear(perform: fetchTodos)
            .onChange(of: selectedDate) { _ in fetchTodos() }
        }
    }
    
    
}

//위젯뷰
struct TodoCardView: View {
    let title: String
    let todos: [Todo]
    @Binding var editingTodoID: PersistentIdentifier?
    @Binding var editingTitle: String
    @Binding var editingStartDate: Date
    @Binding var editingFinishDate: Date
    @Binding var editingNotiTime: Int?
    var onEdit: (Todo) -> Void //데이터 로직을 HomeView에서 가져가기 위해 void함수 생성
    var onSave: (Todo) -> Void
    var onStatusToggle: (Todo) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Text("수정")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .onTapGesture {
                        if let todo = todos.first { onEdit(todo) }
                    }
            }
            ForEach(todos, id: \.id) { todo in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Button(action: { onStatusToggle(todo) }) {
                            Image(systemName: todo.status ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(todo.status ? .cyan : .gray)
                                .font(.title2)
                        }
                        if editingTodoID == todo.persistentModelID {
                            TextField("제목", text: $editingTitle)
                                .font(.system(size: 18, weight: .medium))
                        } else {
                            Text(todo.title)
                                .font(.system(size: 18, weight: .medium))
                        }
                    }
                    if editingTodoID == todo.persistentModelID {
                        HStack {
                            DatePicker("시작", selection: $editingStartDate, displayedComponents: .date)
                            DatePicker("종료", selection: $editingFinishDate, displayedComponents: .date)
                        }
                        HStack {
                            Text("알림")
                            Picker("알림 시간", selection: Binding(get: { editingNotiTime ?? 0 }, set: { editingNotiTime = $0 })) {
                                ForEach(0..<60) { min in
                                    Text("\(min)분 전").tag(min)
                                }
                            }
                        }
                        Button("저장") { onSave(todo) }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.cyan)
                    } else {
                        Text("\(dateString(todo.startDate)) - \(dateString(todo.finishData))")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
    
}

#Preview {
    HomeView()
        .modelContainer(for: Todo.self)
}
