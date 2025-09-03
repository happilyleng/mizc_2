//
//  MusicDetailView.swift
//  mizc2
//
//  Created by Cindy on 2025/8/28.
//

import SwiftUI
import Combine
import AVKit

struct MusicDetailView: View {
    @AppStorage("MusicDetailWidth") private var CoverWidth: Int = 200
    @AppStorage("MusicDetailHeight") private var CoverHeight: Int = 200
    
    @StateObject private var musicplayer = MusicPlayer.shared
    @Binding var isopenmusicdetail: Bool

    var namespace: Namespace.ID
    var coverid: UUID
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            ScrollView {
                if let nowplayingMusicItem = musicplayer.nowplayingMusicItem {
                    VStack {
                        ZStack(alignment: .bottom) {
                            VStack {
                                Spacer()
                                if let cover = nowplayingMusicItem.cover {
                                    let id = nowplayingMusicItem.id
                                    CoverImage(coverimage: cover, namespace: namespace, coverid: id)
                                        .frame(width: CGFloat(CoverWidth),height: CGFloat(CoverHeight))
                                        .scaleEffect(musicplayer.isPlaying ? 1 : 0.5)
                                }
                                Spacer()
                            }
                            .ignoresSafeArea()
                            VStack(spacing:4) {
                                Spacer()
                                ProgressBarView()
                                ControlTools()
                            }
                            .ignoresSafeArea()
                        }
                        .padding(.vertical,30)
                        Text(nowplayingMusicItem.name)
                            .bold()
                            .font(.title3)
                        MusicDetailPlaylistView()
                            .padding(.bottom,30)
                    }
                }
            }
            .tabViewStyle(.verticalPage)
            .ignoresSafeArea()
        }
        .navigationTitle(musicplayer.nowplayingMusicItem?.name ?? "")
        .ignoresSafeArea()
    }
}
