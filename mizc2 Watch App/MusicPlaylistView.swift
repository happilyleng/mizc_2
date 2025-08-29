//
//  MusicPlaylistView.swift
//  mizc2
//
//  Created by Cindy on 2025/8/29.
//

import SwiftUI
import Combine

struct MusicPlaylistView: View {
    @StateObject private var musicplayer = MusicPlayer.shared
    @State private var selectedTab = 0
    
    var body: some View {
        let playlist = musicplayer.playlist
        if !playlist.isEmpty {
            VStack {
                if selectedTab >= 1 {
                    if let previousitem = playlist[selectedTab - 1].musicitem.cover {
                        Image(uiImage: previousitem)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .frame(width: 40, height: 40)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 40,height: 40)
                        .foregroundStyle(Color.clear)
                }
                Spacer()
                
                TabView(selection: $selectedTab) {
                    ForEach(Array(playlist.enumerated()), id: \.element.id) { index,item in
                        if let cover = item.musicitem.cover {
                            VStack {
                                Image(uiImage: cover)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 100, height: 100)
                            }
                            .tag(index)
                        }
                    }
                }
                .tabViewStyle(.verticalPage)
                
                Spacer()
                if playlist.count > selectedTab + 1{
                    if let previousitem = playlist[selectedTab + 1].musicitem.cover {
                        Image(uiImage: previousitem)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .frame(width: 40, height: 40)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 40,height: 40)
                        .foregroundStyle(Color.clear)
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    selectedTab = musicplayer.playingIndex
                }
            }
            .ignoresSafeArea()
        } else {
            Text("没有歌曲")
        }
    }
}
