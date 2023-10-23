//
//  UserRowView.swift
//  ProfileHeaderLikeTwitter
//
//  Created by paku on 2023/10/23.
//

import SwiftUI

struct UserRowView: View {
    
    let image: String
    let username: String
    let bio: String
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 12) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(username)
                            .font(.subheadline).bold()
                            .foregroundStyle(.black)
                        
                        Text("@\(username)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    CapsuleButton(title: "Follow")
                }
                Text(bio)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

#Preview {
    UserRowView(image: "profile", username: "Glace Lee", bio: "Digital nomad & freelance designer | Passionate about sustainable living 🌍 | Cat mom 🐱 | Exploring the world one coffee at a time ☕️ | #Wanderlust #EcoWarrior")
}
