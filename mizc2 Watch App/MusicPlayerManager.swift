//
//  MusicPlayerManager.swift
//  mizc2
//
//  Created by Cindy on 2025/8/28.
//

import SwiftUI
import Combine
import MediaPlayer
import AVKit

final class tempMusicSelecter: ObservableObject {
    static let shared = tempMusicSelecter()
    
    @StateObject private var musicplayer = MusicPlayer.shared
    
    @Published var selectedMusicItem: MusicItem?
    
    func select(selecteditem: MusicItem) {
        selectedMusicItem = selecteditem
    }
    
    func play(selecteditem: MusicItem) {
        selectedMusicItem = selecteditem
        musicplayer.start()
    }
}

struct MusicListItem: Identifiable {
    let id = UUID()
    var musicitem: MusicItem
}

final class MusicPlayer: ObservableObject {
    static let shared = MusicPlayer()
    
    @Published var playlist:[MusicListItem] = []
    @Published var playingIndex: Int = 0
    
    @StateObject private var tempmusicselecter = tempMusicSelecter.shared
    
    @Published private var errors: String = ""
    @Published var nowplayer: AVPlayer?
    @Published var nowplayingMusicItem: MusicItem?
    
    func start() {
        if let selectedMusicItem = tempmusicselecter.selectedMusicItem {
            let playlistitem = MusicListItem(musicitem: selectedMusicItem)
            if playingIndex >= playlist.count {
                playlist.append(playlistitem)
                let player = AVPlayer(url: playlist[playingIndex].musicitem.pth)
                nowplayer = player
                nowplayingMusicItem = selectedMusicItem
                
                player.play()
                setupNowPlayingInfo(with: selectedMusicItem, player: player)
            } else {
                playlist.insert(playlistitem, at: (playingIndex + 1))
                let player = AVPlayer(url: playlist[(playingIndex + 1)].musicitem.pth)
                nowplayer = player
                nowplayingMusicItem = selectedMusicItem
                
                player.play()
                setupNowPlayingInfo(with: selectedMusicItem, player: player)
            }
            if let index = playlist.firstIndex(where: { $0.id == playlistitem.id }) {
                playingIndex = index
            }
            print(playingIndex)
        }
    }
    
    private func setupNowPlayingInfo(with: MusicItem, player: AVPlayer) {
        let title = with.name
        let artist = ""
        
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: artist,
            MPMediaItemPropertyPlaybackDuration: player.currentItem?.asset.duration.seconds ?? 0,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime().seconds ?? 0
        ]
        
        if let artwork = with.cover {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size) { _ in artwork }
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
