//
//  MusicList.swift
//  mizc2
//
//  Created by Cindy on 2025/8/27.
//

import SwiftUI
import Combine

struct MusicListMainView: View {
    @StateObject private var tempmusicseleter = tempMusicSelecter.shared

    @State private var viewWidth: CGFloat = 0
    @State private var viewHeight: CGFloat = 0
    @State private var isopenmusicdetail: Bool = false
    @State private var islongpress: Bool = false
    @State private var isshowplaylist: Bool = false
    
    @Namespace private var animationNamespcace
    
    var body: some View {
        Group {
            if !isopenmusicdetail {
                MusicListView(isopenmusicdetail: $isopenmusicdetail, islongpress: $islongpress, namespace: animationNamespcace)
                    .toolbar{
                        ToolbarItem(placement: .bottomBar) {
                            Button(action: {
                                isshowplaylist.toggle()
                            }) {
                                Text("go")
                            }
                        }
                    }
                    .sheet(isPresented: $isshowplaylist) {
                        MusicPlaylistView()
                    }
            } else {
                Color.white.ignoresSafeArea()
                if let coverid = tempmusicseleter.selectedMusicItem?.id {
                    MusicDetailView(isopenmusicdetail: $isopenmusicdetail, namespace: animationNamespcace, coverid: coverid)
                        .toolbar{
                            ToolbarItem(placement: .cancellationAction) {
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        isopenmusicdetail.toggle()
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                }
            }
        }
    }
}

struct MusicListView: View {
    @StateObject private var searchMusic = SearchMusic.shared
    @StateObject private var tempmusicseleter = tempMusicSelecter.shared

    @Binding var isopenmusicdetail: Bool
    @Binding var islongpress: Bool

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var namespace: Namespace.ID
    
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
                                        withAnimation(.spring(duration: 0.5)) {
                                            if islongpress == false {
                                                tempmusicseleter.play(selecteditem: item)
                                                
                                                isopenmusicdetail.toggle()
                                            }
                                        }
                                    }) {
                                        VStack {
                                            if let cover = item.cover {
                                                CoverImage(coverimage: cover, namespace: namespace, coverid: item.id)
                                                    .frame(width: 100, height: 100)
                                            } else {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(5)
                                                    .overlay(Text("没有封面").font(.caption2))
                                            }
                                        }
                                        .padding(.vertical, 4)
                                    }
                                    .buttonStyle(.plain)
                                    .simultaneousGesture(
                                        LongPressGesture(minimumDuration: 1)
                                            .onEnded{ _ in
                                                tempmusicseleter.select(selecteditem: item)
                                                
                                                islongpress.toggle()
                                            }
                                    )
                                    
                                    Text(item.name)
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .padding(2)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $islongpress) {
            LongPressView()
        }
        .task {
            await searchMusic.fetchMusicItems()
        }
        .navigationTitle("MIZC2")
    }
}
