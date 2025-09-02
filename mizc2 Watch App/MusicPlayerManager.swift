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
import AVFoundation

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
    @Published var isPlaying: Bool = false
    
    @StateObject private var tempmusicselecter = tempMusicSelecter.shared
    
    @Published private var errors: String = ""
    @Published var nowplayer: AVPlayer?
    @Published var nowplayingMusicItem: MusicItem?
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var progress: Double = 0
    @Published var formattedTime: String = "00:00"
    
    private var timeObserver: Any?
    
    func start() {
        moveMusic()
        
        if let selectedMusicItem = tempmusicselecter.selectedMusicItem {
            let playlistitem = MusicListItem(musicitem: selectedMusicItem)
            if playingIndex >= playlist.count {
                playlist.append(playlistitem)
                let player = AVPlayer(url: playlist[playingIndex].musicitem.pth)
                nowplayer = player
                nowplayingMusicItem = selectedMusicItem
                
                player.play()
                addTimeObserver()
                addEndObserver(for: player)
                isPlaying = true
                setupNowPlayingInfo(with: selectedMusicItem, player: player)
            } else {
                playlist.insert(playlistitem, at: (playingIndex + 1))
                let player = AVPlayer(url: playlist[(playingIndex + 1)].musicitem.pth)
                nowplayer = player
                nowplayingMusicItem = selectedMusicItem
                
                player.play()
                addTimeObserver()
                addEndObserver(for: player)
                isPlaying = true
                setupNowPlayingInfo(with: selectedMusicItem, player: player)
            }
            if let index = playlist.firstIndex(where: { $0.id == playlistitem.id }) {
                playingIndex = index
            }
            if let duration = nowplayer?.currentItem?.asset.duration {
                self.duration = CMTimeGetSeconds(duration)
            }
        }
    }
    
    private func setupNowPlayingInfo(with: MusicItem, player: AVPlayer) {
        let title = with.name
        let artist = ""
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession:", error)
        }
        
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
    
    func moveMusic() {
        if let current = nowplayer {
            current.pause()
            current.replaceCurrentItem(with: nil)
        }
        isPlaying = false
        nowplayingMusicItem = nil
    }
    
    func pause(){
        isPlaying = false
        nowplayer?.pause()
    }
    func play(){
        isPlaying = true
        nowplayer?.play()
    }
    func seek(to: Double) {
        let time = CMTime(seconds: to, preferredTimescale: 600)
        nowplayer?.seek(to: time)
    }
    
    func previou() {
        if playingIndex > 0 {
            moveMusic()
            let player = AVPlayer(url: playlist[(playingIndex - 1)].musicitem.pth)
            nowplayer = player
            nowplayingMusicItem = playlist[(playingIndex - 1)].musicitem
            
            player.play()
            addTimeObserver()
            addEndObserver(for: player)
            isPlaying = true
            setupNowPlayingInfo(with: playlist[(playingIndex - 1)].musicitem, player: player)
            playingIndex -= 1
            if let duration = nowplayer?.currentItem?.asset.duration {
                self.duration = CMTimeGetSeconds(duration)
            }
        }
    }
    func next() {
        if playingIndex + 1 < playlist.count {
            moveMusic()
            let player = AVPlayer(url: playlist[(playingIndex + 1)].musicitem.pth)
            nowplayer = player
            nowplayingMusicItem = playlist[(playingIndex + 1)].musicitem
            
            player.play()
            addTimeObserver()
            addEndObserver(for: player)
            isPlaying = true
            setupNowPlayingInfo(with: playlist[(playingIndex + 1)].musicitem, player: player)
            playingIndex += 1
            if let duration = nowplayer?.currentItem?.asset.duration {
                self.duration = CMTimeGetSeconds(duration)
            }
        }
    }
    
    private func addTimeObserver() {
        guard let player = nowplayer else { return }
        
        let interval = CMTime(seconds: 1.0, preferredTimescale: 2)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            let current = CMTimeGetSeconds(time)
            self.currentTime = current
            
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? .zero)
            if duration > 0 {
                self.progress = current / duration
            } else {
                self.progress = 0
            }
            
            self.formattedTime = Self.formatTime(seconds: current)
        }
    }
    private func addEndObserver(for player: AVPlayer) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.next()
        }
    }
    
    static func formatTime(seconds: Double) -> String {
        guard !seconds.isNaN && seconds.isFinite else { return "00:00" }
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    deinit {
        if let observer = timeObserver {
            nowplayer?.removeTimeObserver(observer)
        }
    }
}
