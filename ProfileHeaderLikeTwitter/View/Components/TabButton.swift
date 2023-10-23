//
//  TabButton.swift
//  ProfileHeaderLikeTwitter
//
//  Created by paku on 2023/10/23.
//

import SwiftUI

struct TabButton: View {
    
    var tab: TabFilter
    @Binding var currentTab: TabFilter
    var animation: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation {
                currentTab = tab
            }
        } label: {
            VStack(spacing: 12) {
                Text(tab.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(currentTab == tab ? .blue : .gray)
                
                if currentTab == tab {
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: 70, height: 3)
                        .matchedGeometryEffect(id: "TABBAR", in: animation)
                } else {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 3)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
