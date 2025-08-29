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
    @Binding var isshow: Bool
    
    var body: some View {
        if let selectedMusicItem = tempMusicSeleter.selectedMusicItem {
            Form {
                Button(action: {
                    let playlistitem = MusicListItem(musicitem: selectedMusicItem)
                    if musicplayer.playingIndex >= musicplayer.playlist.count {
                        musicplayer.playlist.append(playlistitem)
                    } else {
                        musicplayer.playlist.insert(playlistitem, at: (musicplayer.playingIndex + 1))
                    }
                    isshow = false
                }) {
                    Text("下一首播放")
                        .bold()
                        .foregroundStyle(Color.white)
                        .padding()
                }
                
                Button(action: {
                    let playlistitem = MusicListItem(musicitem: selectedMusicItem)
                    musicplayer.playlist.append(playlistitem)
                    isshow = false
                }) {
                    Text("加入播放列表")
                        .bold()
                        .foregroundStyle(Color.white)
                        .padding()
                }
            }
            .navigationTitle(selectedMusicItem.name)
        } else {
            Text("玄学问题，妙哉")
        }
    }
}
