//
//  CoverImage.swift
//  mizc2
//
//  Created by Cindy on 2025/8/27.
//

import SwiftUI

struct CoverImage: View {
    var coverimage: UIImage
    @State private var viewWidth: CGFloat = 0
    @State private var viewHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: coverimage)
                    .resizable()
                    .scaledToFit()
                    .blur(radius: 20)
                    .frame(width: viewWidth + 5, height: viewHeight + 5)
                
                Image(uiImage: coverimage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .frame(width: (viewWidth - 10), height: (viewHeight - 10))
            }
            .onAppear {
                viewWidth = geometry.size.width
                viewHeight = geometry.size.height
            }
        }
    }
}
