//
//  Home.swift
//  ProfileHeaderLikeTwitter
//
//  Created by paku on 2023/10/23.
//

import SwiftUI

struct Home: View {
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                GeometryReader { proxy -> AnyView in
                    
                    let minY = proxy.frame(in: .global).minY
                    print(minY)
                    
                    let screenWidth = UIScreen.main.bounds.width
                    let height: CGFloat = 180
                    //これを囲まないと
                    //「Modifying state during view update, this will cause undefined behavior.」警告がでる
                    // 要は、scrollすると minY -> @State offsetに新しい値が代入され
                    // 代入による、再描画のupdateになるので再帰的呼び出し無限ループに陥る
                    // @State offset更新を非同期にすることで再描画が完了した後に状態を変更できる
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    
                    return AnyView(
                        ZStack {
                            Image("tesla")
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenWidth, 
                                       height: minY > 0 ? height + minY : height, alignment: .center)
                        }
                        // 下にスクロール時はheaderを固定
                        .offset(y: minY > 0 ? -minY : 0)
                        
                        
                    )
                    
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
