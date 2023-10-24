//
//  ProfileView.swift
//  ProfileHeaderLikeTwitter
//
//  Created by paku on 2023/10/23.
//

import SwiftUI

enum TabFilter: Int, Identifiable, CaseIterable {
    case posts
    case replies
    case highlights
    case likes
    
    var title: String {
        switch self {
        case .posts: "Posts"
        case .replies: "Replies"
        case .highlights: "Highlights"
        case .likes: "Likes"
        }
    }
    
    var id: Int { self.rawValue }
}

struct ProfileView: View {
    
    @State var offset: CGFloat = 0
    @State var tabBarOffset: CGFloat = 0
    @State var usernameOffset: CGFloat = 0
    
    let screenWidth = UIScreen.main.bounds.width
    let headerImageHeight: CGFloat = 170

    @State var currentTab: TabFilter = .posts
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                GeometryReader { proxy -> AnyView in
                    let minY = proxy.frame(in: .global).minY
                    //これを囲まないと
                    //「Modifying state during view update, this will cause undefined behavior.」警告がでる
                    // 要は、scrollすると minY -> @State offsetに新しい値が代入され
                    // 代入による、再描画のupdateになるので再帰的呼び出し無限ループに陥る
                    // @State offset更新を非同期にすることで再描画が完了した後に状態を変更できる
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    
                    return headerImage
                }
                .frame(height: headerImageHeight)
                .zIndex(-offset > 80 ? 1 : 0)
                
                HStack {
                    profileIcon
                        .scaleEffect(getScale())
                    
                    Spacer()
                    
                    editButton
                        .offset(y: 5)
                }
                .padding(.horizontal)
                .padding(.vertical, -30)
                .zIndex(0)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Grace Lee")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .overlay(
                            GeometryReader { proxy -> Color in
                                let minY = proxy.frame(in: .global).minY
                                
                                DispatchQueue.main.async {
                                    usernameOffset = minY
                                }
                                return .clear
                            }
                        )
                    
                    Text("@grace_lee")
                        .foregroundStyle(.gray)
                                        
                    Text("🌸 Digital nomad & freelance iOS Engineer | Passionate about sustainable living 🌍 | I loving Tesla 🚘 | Exploring the world one coffee at a time ☕️ | #Wanderlust #EcoWarrior")
                    
                    HStack {
                        Text("324")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                        
                        Text("Following")
                            .foregroundStyle(.gray)
                        
                        Text("1,203")
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                        
                        Text("Followers")
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // TabBarButton
                tabBarButton
                    .offset(y: tabBarOffset < 90 ? -tabBarOffset + 90 : 0)
                    .overlay(
                        GeometryReader { proxy -> Color in
                            
                            let minY = proxy.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                self.tabBarOffset = minY
                            }
                            
                            return Color.clear
                        }
                    )
                    .zIndex(2)
                
                
                // Contents
                userLowViewListView
            }
        }
        .ignoresSafeArea()
        .overlay(naviHeader, alignment: .top)
    }
    
    func getScale() -> CGFloat {
        if -offset > 80 {
            // scroll量が80を超えたら 0.5のスケールを保つ
            return 0.5
        } else {
            // 下にscrollの場合スケールは1 それ以外、上にscrollした量が80まで、scrollの半分の量(1 * 0.5)でアイコンを縮小
            return offset > 0 ? 1 : 1 - ((-offset / 80) * 0.5)
        }
    }
    
    func getOpacity() -> CGFloat {
        if offset <= 0 {
            return 0
        } else {
            return min(1, max(0, offset - offset * 0.985))
        }
    }
        
    func getUsernameOffset() -> CGFloat {
        if usernameOffset < 60 {
            return -usernameOffset + 60
        }
        return 0
    }
    
    func getUsernameOpacity() -> CGFloat {
        // Trigger Stated at 80
        // End at 60
        // 80 = 0
        // 60 = 1
        let opacity = (80 / (usernameOffset ) - 1) * 2
        
        if usernameOffset < 80 {
            // 80未満からは 0...1 にopacityを変更していく
            let opacity = (80 / (usernameOffset ) - 1) * 2 // 2: scroll分の2倍速さにする
            return usernameOffset < 60 ? 1 : opacity
            
        } else {
            return 0
        }
    }
}

extension ProfileView {
    
    var naviHeader: some View {
        HStack {
            Image(systemName: "arrow.left")
                .font(.callout)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.black.opacity(0.4))
                .clipShape(Circle())
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.callout)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.black.opacity(0.4))
                .clipShape(Circle())
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .offset(y: -2)
                .padding(4)
                .background(Color.black.opacity(0.4))
                .clipShape(Circle())
        }
        .padding(.horizontal)
    }
    
    var headerImage: AnyView {
        AnyView(
            
            ZStack(alignment: .bottom) {
                Image("tesla")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth,
                           // 下にscrollした分 heightの高さをincrementする
                           height: offset > 0 ? headerImageHeight + offset : headerImageHeight, alignment: .center)
                    .clipShape(Rectangle())
                    .overlay(BlurView().opacity(getOpacity()))
                // 下にスクロール時はheaderを固定
                .offset(y:
                            // scroll down offset: 相殺して　y:0 positionを維持
                            offset > 0 ?  -offset :
                           
                            // scroll up
                            // (offset > -80 ? 0) 80までは offsetを0にしているので headerImageはScrollViewのスクロールに合わせて動く
                            // 80を超えた場合 (-80 - offset) y:-80の位置から （scrollした分 - offset分)で相殺し -80ポジションを維持させる
                            offset > -80 ? 0 : -80 - offset)
                
                
                HStack {
                    Text("Grace Lee")
                        .bold()
                        .foregroundStyle(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 5)
                        .opacity(getUsernameOpacity())
                        .offset(y: getUsernameOffset())
                    
                    Spacer()
                }
                .padding(.horizontal, 50)
                .offset(y: 88)
                
            }
        )
    }
    
    var profileIcon: some View {
        Image("profile")
            .resizable()
            .scaledToFill()
            .frame(width: 75, height: 75)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 6))
            .zIndex(0)

    }
    
    var editButton: some View {
        Button {
            
        } label: {
            Text("Edit Profile")
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
    
    var tabBarButton: some View {
        HStack {
            ForEach(TabFilter.allCases) { tab in
                TabButton(tab: tab, currentTab: $currentTab, animation: animation)
            }
        }
        .padding(.top, 10)
        .background(.white)
        .overlay(Divider(), alignment: .bottom)
    }
    
    var userLowViewListView: some View {
        VStack(spacing: 12) {
            UserRowView(image: "profile", username: "Glace Lee", bio: "Digital nomad & freelance designer | Passionate about sustainable living 🌍 | Cat mom 🐱 | Exploring the world one coffee at a time ☕️ | #Wanderlust #EcoWarrior")
            UserRowView(image: "profile2", username: "Chloe Miller", bio: "🚀 Tech enthusiast & budding entrepreneur | Advocating for mental wellness 🧠 | Dog lover 🐶 | Dive deep into books every night 📚 | #TechGeek #MindfulLiving")
            UserRowView(image: "profile3", username: "Samuel Clark", bio: "Digital nomad & freelance designer | Passionate about sustainable living 🌍 | Cat mom 🐱 | Exploring the world one coffee at a time ☕️ | #Wanderlust #EcoWarrior")
            UserRowView(image: "profile4", username: "Glace Lee", bio: "🚀 Tech enthusiast & budding entrepreneur | Advocating for mental wellness 🧠 | Dog lover 🐶 | Dive deep into books every night 📚 | #TechGeek #MindfulLiving")
            UserRowView(image: "profile", username: "Glace Lee", bio: "Digital nomad & freelance designer | Passionate about sustainable living 🌍 | Cat mom 🐱 | Exploring the world one coffee at a time ☕️ | #Wanderlust #EcoWarrior")
            UserRowView(image: "profile2", username: "Chloe Miller", bio: "🚀 Tech enthusiast & budding entrepreneur | Advocating for mental wellness 🧠 | Dog lover 🐶 | Dive deep into books every night 📚 | #TechGeek #MindfulLiving")
            UserRowView(image: "profile3", username: "Samuel Clark", bio: "Digital nomad & freelance designer | Passionate about sustainable living 🌍 | Cat mom 🐱 | Exploring the world one coffee at a time ☕️ | #Wanderlust #EcoWarrior")
            UserRowView(image: "profile4", username: "Glace Lee", bio: "🚀 Tech enthusiast & budding entrepreneur | Advocating for mental wellness 🧠 | Dog lover 🐶 | Dive deep into books every night 📚 | #TechGeek #MindfulLiving")
        }
    }
}

#Preview {
    ProfileView()
}
