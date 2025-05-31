import SwiftUI
import SwiftData

import SwiftUI

struct AddTodoView: View {

    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var useAlarm: Bool = true
    @State private var alarmTime: Int = 5
    @State private var isTodayTask: Bool = true
    @State private var showDatePicker: Bool = false
    @State private var showAlarmPicker: Bool = false
    
    let alarmTimes = [5, 10, 15, 20, 25, 30, 60, 120]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("할 일 추가")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("할 일")
                        .font(.title3)
                        .fontWeight(.bold)

                    TextField("", text: $title)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .cornerRadius(8)

                    Text("기간 설정")
                        .font(.title3)
                        .fontWeight(.bold)

                    HStack {
                        Button(action: {
                            isTodayTask = false
                        }) {
                            Text("기간 할 일")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(!isTodayTask ? Color(hex: "00FFFF") : .gray, lineWidth: 2)
                                )
                                .foregroundColor(!isTodayTask ? Color(hex: "00FFFF") : .gray)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            isTodayTask = true
                            date = Date()
                        }) {
                            Text("오늘 할 일")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(isTodayTask ? Color(hex: "00FFFF") : .gray, lineWidth: 2)
                                )
                                .foregroundColor(isTodayTask ? Color(hex: "00FFFF") : .gray)
                                .cornerRadius(8)
                        }
                    }

//                    if isTodayTask {
//                        HStack {
//                            Spacer()
//                            Text(formattedDate(date))
//                                .foregroundColor(.black)
//                            Spacer()
//                        }
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
//                    } else {
                    if !isTodayTask {
                        Button(action: {
                            showDatePicker.toggle()
                        }) {
                            HStack {
                                Spacer()
                                Text(formattedDate(date))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(showDatePicker ? 180 : 0))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .cornerRadius(8)
                        }

                        if showDatePicker {
                            DatePicker("", selection: $date, displayedComponents: [.date])
                                .datePickerStyle(.wheel)
                                .environment(\.locale, Locale(identifier: "ko_KR"))
                                .labelsHidden()
                        }
                    }

                    Text("알림 사용")
                        .font(.title3)
                        .fontWeight(.bold)

                    HStack {
                        Button(action: {
                            useAlarm = false
                        }) {
                            Text("미사용")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(!useAlarm ? Color(hex: "00FFFF") : .gray, lineWidth: 2)
                                )
                                .foregroundColor(!useAlarm ? Color(hex: "00FFFF") : .gray)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            useAlarm = true
                        }) {
                            Text("사용")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(useAlarm ? Color(hex: "00FFFF") : .gray, lineWidth: 2)
                                )
                                .foregroundColor(useAlarm ? Color(hex: "00FFFF") : .gray)
                                .cornerRadius(8)
                        }
                    }

                    if useAlarm {
                        Button(action: {
                            showAlarmPicker.toggle()
                        }) {
                            HStack {
                                Spacer()
                                Text(alarmTime >= 60 ? "\(alarmTime / 60)시간 전" : "\(alarmTime)분 전")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(showAlarmPicker ? 180 : 0))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .cornerRadius(8)
                        }

                        if showAlarmPicker {
                            Picker("알림 시간", selection: $alarmTime) {
                                ForEach(alarmTimes, id: \.self) { time in
                                    Text(time >= 60 ? "\(time / 60)시간 전" : "\(time)분 전")
                                        .tag(time)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 100)
                        }
                    }

                    Button(action: {
                        // 저장 로직 구현 가능
                        dismiss()
                    }) {
                        Text("추가 하기")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "0BCCFA"))
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

private extension AddTodoView {
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

