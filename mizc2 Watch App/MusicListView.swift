//
//  MusicList.swift
//  mizc2
//
//  Created by Cindy on 2025/8/27.
//

import SwiftUI
import Combine

struct MusicListView: View {
    @StateObject private var searchMusic = SearchMusic.shared
    
    @State private var viewWidth: CGFloat = 0
    @State private var viewHeight: CGFloat = 0
    
    @Namespace private var animation
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if searchMusic.musicitems.isEmpty {
                VStack {
                    Text("没有找到音乐")
                    Text("请在手机上添加音乐")
                }
            } else {
                GeometryReader { geometry in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(searchMusic.musicitems) { item in
                                VStack {
                                    Button(action: {
                                        print("按下了\(item.name)")
                                    }) {
                                        VStack {
                                            if let cover = item.cover {
                                                CoverImage(coverimage: cover)
                                                    .frame(width: 100, height: 100)
                                            } else {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(5)
                                                    .overlay(Text("No Cover").font(.caption2))
                                            }
                                        }
                                        .padding(.vertical, 4)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Text(item.name)
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .multilineTextAlignment(.center)  // 居中文本
                                        .padding(2)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .task {
            await searchMusic.fetchMusicItems()
        }
        .navigationTitle("MIZC2")
    }
}

