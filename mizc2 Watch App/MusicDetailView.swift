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
    @StateObject private var musicplayer = MusicPlayer.shared
    @Binding var isopenmusicdetail: Bool
    var namespace: Namespace.ID
    var coverid: UUID
    
    var body: some View {
        if let nowplayingMusicItem = musicplayer.nowplayingMusicItem {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    Spacer()
                    if let cover = nowplayingMusicItem.cover {
                        let id = nowplayingMusicItem.id
                        CoverImage(coverimage: cover, namespace: namespace, coverid: id)
                            .frame(width: 200,height: 200)
                    }
                    Spacer()
                }
                .ignoresSafeArea()
            }
        }
    }
}
