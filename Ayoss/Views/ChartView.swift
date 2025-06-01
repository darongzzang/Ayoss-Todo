//
//  ChartView.swift
//  Ayoss
//
//  Created by 김이예은 on 5/17/25.
//

//
//  ChartView.swift
//  swift_test
//
//  Created by 이한 on 5/20/25.
//

import Foundation
import SwiftUI
import Charts
import UIKit

struct MonthlyStat: Identifiable {
    let id = UUID()
    let month: Int
    let completed: Int
}

struct ChartView: View {
    // 이전 3개월 데이터
    let stats: [MonthlyStat]
    // 리스트 개수, 완료 개수
    let totalThisMonth: Int
    let completedThisMonth: Int

    // 평균선 위치
    private var average: Double {
        guard !stats.isEmpty else { return 0 }
        let sum = stats.map { $0.completed }.reduce(0, +)
        return Double(sum) / Double(stats.count)
    }
    // 현재 월
    private var currentMonth: Int {
        stats.last?.month ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 5월
            HStack {
                Text("\(currentMonth)월")
                    .font(.title2).bold()
                Spacer()
                Button {
                    // 다음 달 이동 로직 필요
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(Color(.sRGB,
                                               red:   0x0B/255.0,
                                               green: 0xCC/255.0,
                                               blue:  0xFA/255.0,
                                               opacity: 1))
                }
            }

            // 설명
            Text("이번달은 \(totalThisMonth)개의 투두 리스트 중 \(completedThisMonth)개의 일을 완료했어요!")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            // 차트
            Chart {
                // 바 차트
                ForEach(stats) { stat in
                    BarMark(
                        x: .value("Month", "\(stat.month)월"),
                        y: .value("Completed", stat.completed)
                    )
                    .foregroundStyle(stat.month == currentMonth
                                     ? Color.blue
                                     : Color.gray.opacity(0.3))
                }

                // 평균선
                RuleMark(y: .value("Average", average))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.primary)
                    .annotation(position: .trailing) {
                        Text("평균")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
            }
//            .chartYAxis(.hidden)  // y축 숨기기
            .frame(height: 650)
        }
        .padding()
    }
}

// MARK: - Preview

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        // 미리보기용
        let dummyStats = [
            MonthlyStat(month: 3, completed: 5),
            MonthlyStat(month: 4, completed: 8),
            MonthlyStat(month: 5, completed: 12)
        ]
        ChartView(
            stats: dummyStats,
            totalThisMonth: 15,
            completedThisMonth: 12
        )
    }
}
