//
//  CapsuleButton.swift
//  ProfileHeaderLikeTwitter
//
//  Created by paku on 2023/10/23.
//

import SwiftUI

struct CapsuleButton: View {
    
    let title: String
    
    var body: some View {
        Button {
            
        } label: {
            Text(title)
                .bold()
                .foregroundStyle(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 30)
                .background(
                    Capsule()
                        .fill(.black)
                )
        }
    }
}

#Preview {
    CapsuleButton(title: "Edit Profile")
}
