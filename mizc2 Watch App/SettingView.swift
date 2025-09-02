//
//  SettingView.swift
//  mizc2
//
//  Created by Cindy on 2025/8/29.
//

import SwiftUI
import Combine

struct SettingView: View {
    @AppStorage("MusicDetailWidth") private var CoverWidth: Int = 100
    @AppStorage("MusicDetailHeight") private var CoverHeight: Int = 100
    @AppStorage("MusicListWidth") private var MusicListWidth: Int = 100
    @AppStorage("MusicListHeight") private var MusicListHeight: Int = 100
    
    @State private var coverSize: CGFloat = 100
    @State private var musiclistSize: CGFloat = 100
    @State private var ischanging: Bool = false
    @State private var crownEnabled: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TabView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.blue)
                        .frame(width: coverSize, height: coverSize)
                        .focusable(true)
                        .focused($isFocused)
                        .digitalCrownRotation(
                            crownEnabled ? $coverSize : .constant(coverSize),
                            from: 150,
                            through: 200,
                            by: 1,
                            sensitivity: .medium,
                            isHapticFeedbackEnabled: true
                        )
                        .onChange(of: coverSize) { newValue in
                            CoverWidth = Int(newValue)
                            CoverHeight = Int(newValue)
                            withAnimation{
                                ischanging = true
                            }
                        }
                        .onAppear {
                            crownEnabled = false
                            ischanging = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                coverSize = CGFloat(max(CoverWidth, CoverHeight))
                                crownEnabled = true
                            }
                        }
                    VStack {
                        Text("\(CoverWidth)")
                    }
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                        Text("滑动改变详情页封面大小")
                            .bold()
                            .foregroundStyle(Color.white)
                    }
                    .opacity(ischanging ? 0 : 1)
                    .animation(.easeOut(duration: 0.8), value: ischanging)
                }
            }
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.blue)
                        .frame(width: musiclistSize, height: musiclistSize)
                        .focusable(true)
                        .focused($isFocused)
                        .digitalCrownRotation(
                            crownEnabled ? $musiclistSize : .constant(musiclistSize),
                            from: 80,
                            through: 120,
                            by: 1,
                            sensitivity: .medium,
                            isHapticFeedbackEnabled: true
                        )
                        .onChange(of: musiclistSize) { newValue in
                            MusicListWidth = Int(newValue)
                            MusicListHeight = Int(newValue)
                            withAnimation{
                                ischanging = true
                            }
                        }
                        .onAppear {
                            ischanging = false
                            crownEnabled = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                musiclistSize = CGFloat(max(MusicListWidth, MusicListHeight))
                                crownEnabled = true
                            }
                        }
                    VStack {
                        Text("\(MusicListWidth)")
                    }
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                        Text("滑动改变首页封面大小")
                            .bold()
                            .foregroundStyle(Color.white)
                    }
                    .opacity(ischanging ? 0 : 1)
                    .animation(.easeOut(duration: 0.8), value: ischanging)
                }
            }
        }
    }
}
