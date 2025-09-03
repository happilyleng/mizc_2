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
    @StateObject private var musicplayer = MusicPlayer.shared

    @State private var viewWidth: CGFloat = 0
    @State private var viewHeight: CGFloat = 0
    @State private var isopenmusicdetail: Bool = false
    @State private var islongpress: Bool = false
    @State private var isshowplaylist: Bool = false
    @State private var isshowsetting: Bool = false
    
    @Namespace private var animationNamespcace
    
    var body: some View {
        Group {
            if (!isopenmusicdetail && !isshowsetting) {
                MusicListView(isopenmusicdetail: $isopenmusicdetail, islongpress: $islongpress, namespace: animationNamespcace)
                    .toolbar{
                        ToolbarItem(placement: .bottomBar) {
                            Button(action: {
                                isshowplaylist.toggle()
                            }) {
                                Image(systemName: "list.bullet")
                            }
                        }
                        
                        ToolbarItem(placement: .bottomBar) {
                            Button(action: {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    isshowsetting.toggle()
                                }
                            }){
                                Image(systemName: "gear")
                            }
                        }
                        
                        ToolbarItem(placement: .confirmationAction){
                            if musicplayer.nowplayer != nil {
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        isopenmusicdetail.toggle()
                                    }
                                }) {
                                    if let cover = musicplayer.nowplayingMusicItem?.cover {
                                        Image(uiImage: cover)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30,height: 30)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
            } else {
                ZStack {
                    Color.white.ignoresSafeArea()
                    if let coverid = tempmusicseleter.selectedMusicItem?.id {
                        MusicDetailView(isopenmusicdetail: $isopenmusicdetail, namespace: animationNamespcace, coverid: coverid)
                            .ignoresSafeArea()
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
        .sheet(isPresented: $isshowplaylist) {
            MusicPlaylistView()
        }
        .sheet(isPresented: $isshowsetting) {
            SettingView()
        }
    }
}

struct MusicListView: View {
    @AppStorage("MusicListWidth") private var MusicListWidth: Int = 100
    @AppStorage("MusicListHeight") private var MusicListHeight: Int = 100
    
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
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                            if islongpress == false {
                                                tempmusicseleter.play(selecteditem: item)
                                                isopenmusicdetail.toggle()
                                            }
                                        }
                                    }) {
                                        VStack {
                                            if let cover = item.cover {
                                                CoverImage(coverimage: cover, namespace: namespace, coverid: item.id)
                                                    .frame(width: CGFloat(MusicListHeight), height: CGFloat(MusicListHeight))
                                            } else {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: CGFloat(MusicListHeight), height: CGFloat(MusicListHeight))
                                                    .cornerRadius(5)
                                                    .overlay(Text("没有封面").font(.caption2))
                                            }
                                        }
                                        .padding(.vertical, 2)
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
                        .padding(.horizontal,4)
                    }
                }
            }
        }
        .sheet(isPresented: $islongpress) {
            LongPressView(isshow: $islongpress)
        }
        .task {
            await searchMusic.fetchMusicItems()
        }
        .navigationTitle("MIZC2")
    }
}
