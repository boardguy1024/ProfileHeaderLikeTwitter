//
//  BlurView.swift
//  ProfileHeaderLikeTwitter
//
//  Created by paku on 2023/10/23.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let style: UIBlurEffect.Style = .systemChromeMaterialDark
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))

        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

#Preview {
    BlurView()
}
