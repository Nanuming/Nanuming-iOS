//
//  MyPostView.swift
//  Nanuming
//
//  Created by 가은 on 2/17/24.
//

import SwiftUI

enum myPostTapInfo: String, CaseIterable {
    case beforeCreate = "등록 대기"
    case waiting = "나눔 중"
    case reserving = "예약 중"
    case complete = "나눔 완료"
}

struct MyPostView: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        Picker("Flavor", selection: $selectedTab) {
            ForEach(myPostTapInfo.allCases.indices, id: \.self) { index in
                Text(myPostTapInfo.allCases[index].rawValue).tag(index)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        switch selectedTab {
            case 0:
                Text("첫 번째 탭의 내용")
            case 1:
                Text("2 번째 탭의 내용")
            case 2:
                Text("3 번째 탭의 내용")
            default:
                Text("4 번째 탭의 내용")
        }
        Spacer()
    }
}

#Preview {
    MyPostView()
}
