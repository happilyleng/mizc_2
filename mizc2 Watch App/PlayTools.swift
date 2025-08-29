//
//  PlayTools.swift
//  mizc2
//
//  Created by Cindy on 2025/8/29.
//

import SwiftUI
import Combine
import AVFoundation

struct ControlTools: View {
    @StateObject private var musicplayer = MusicPlayer.shared
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation {
                    musicplayer.previou()
                }
            }) {
                Image(systemName: "backward.fill")
                    .font(.title2)
            }
            Spacer()
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    if let player = musicplayer.nowplayer {
                        if musicplayer.isPlaying {
                            musicplayer.pause()
                        } else {
                            musicplayer.play()
                        }
                    }
                }
            }) {
                Image(systemName: musicplayer.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title)
            }
            Spacer()
            Button(action: {
                withAnimation {
                    musicplayer.next()
                }
            }) {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            Spacer()
        }
        .buttonStyle(.plain)
        .padding()
    }
}

struct ProgressBarView: View {
    @StateObject private var player = MusicPlayer.shared
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var dragProgress: CGFloat = 0
    
    var body: some View {
        let currentTime = player.currentTime
        let totalDuration = player.duration
        
        VStack {
            GeometryReader { geometry in
                let progress = min(max(currentTime / totalDuration, 0), 1)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: geometry.size.width, height: geometry.size.height)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * (isDragging ? dragProgress : CGFloat(progress)),
                               height: geometry.size.height)
                }
                .cornerRadius(8)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDragging {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                player.pause()
                            }
                            isDragging = true
                        }
                        
                        dragProgress = min(max(value.location.x / geometry.size.width, 0), 1)
                        dragOffset = value.location.x
                    }
                    .onEnded { _ in
                        isDragging = false
                        player.seek(to: Double(dragProgress * CGFloat(totalDuration)))
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            player.play()
                        }
                    }
                )
            }
            .frame(width: .infinity, height: 10)
            .padding(.horizontal,10)

            HStack {
                let showingTime = isDragging ? Double(dragProgress) * totalDuration : currentTime
                Text(formatTime(showingTime))
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text("---")
                
                Text(formatTime(totalDuration))
                    .font(.caption)
                    .foregroundColor(.pink)
            }
        }
    }

    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
