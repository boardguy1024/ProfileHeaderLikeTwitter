//
//  Home.swift
//  ProfileHeaderLikeTwitter
//
//  Created by paku on 2023/10/23.
//

import SwiftUI

struct Home: View {
    
    @State var offset: CGFloat = 0
    let screenWidth = UIScreen.main.bounds.width
    let headerImageHeight: CGFloat = 170

    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                GeometryReader { proxy -> AnyView in
                    let minY = proxy.frame(in: .global).minY
                    print(minY)
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
                
                // MARK: - Profile Icon Image
                HStack {
                   
                    profileIcon
                        // scroll量が80を超えたら 0.5のスケールを保つ
                        .scaleEffect(-offset > 80 ? 0.5 :
                                        
                                      // 下にscrollの場合スケールは1 それ以外、上にscrollした量が80まで、scrollの半分の量(1 * 0.5)でアイコンを縮小
                                      offset > 0 ? 1 : 1 - ((-offset / 80) * 0.5))
                    
                    Spacer()
                    
                    editButton
                        .offset(y: 5)
                }
                .padding(.horizontal)
                .padding(.vertical, -30)
                .zIndex(0)
            }
        }
        .ignoresSafeArea()
    }
}

extension Home {
    var headerImage: AnyView {
        AnyView(
            // ----------------------------------------------------
            Image("tesla")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth,
                       // 下にscrollした分 heightの高さをincrementする
                       height: offset > 0 ? headerImageHeight + offset : headerImageHeight, alignment: .center)
                .clipShape(Rectangle())
            // 下にスクロール時はheaderを固定
            .offset(y:
                        // scroll down offset: 相殺して　y:0 positionを維持
                        offset > 0 ?  -offset :
                       
                        // scroll up
                        // (offset > -80 ? 0) 80までは offsetを0にしているので headerImageはScrollViewのスクロールに合わせて動く
                        // 80を超えた場合 (-80 - offset) y:-80の位置から （scrollした分 - offset分)で相殺し -80ポジションを維持させる
                        offset > -80 ? 0 : -80 - offset)
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
}

#Preview {
    ContentView()
}
