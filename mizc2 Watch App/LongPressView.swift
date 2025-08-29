//
//  LongPressView.swift
//  mizc2
//
//  Created by Cindy on 2025/8/28.
//

import SwiftUI
import Combine

struct LongPressView: View {
    @StateObject private var tempMusicSeleter = tempMusicSelecter.shared
    @StateObject private var musicplayer = MusicPlayer.shared
    
    var body: some View {
        if let selectedMusicItem = tempMusicSeleter.selectedMusicItem {
            Form {
                Button(action: {
                    musicplayer.playlist.append(MusicListItem(musicitem: selectedMusicItem))
                }) {
                    Text("")
                }
            }
            .navigationTitle(selectedMusicItem.name)
        } else {
            Text("玄学问题，妙哉")
        }
    }
}
