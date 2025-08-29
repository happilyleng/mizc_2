//
//  ContentView.swift
//  mizc2 Watch App
//
//  Created by Cindy on 2025/8/27.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject private var musicplayer = MusicPlayer.shared
    
    var body: some View {
        ZStack {
            if let nowplayer = musicplayer.nowplayer {
                VideoPlayer(player: nowplayer)
                    .focusable(false)
            }
            Color.white.ignoresSafeArea()
            NavigationStack {
                MusicListMainView()
            }
        }
        .foregroundStyle(Color.pink)
    }
}

#Preview {
    ContentView()
}
