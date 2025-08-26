//
//  SearchMusic.swift
//  mizc2
//
//  Created by Cindy on 2025/8/27.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

struct MusicItem: Identifiable {
    let id = UUID()
    let name: String
    let pth: URL
    let cover: UIImage?
}

@MainActor
final class SearchMusic: ObservableObject {
    static let shared = SearchMusic()
    
    @Published var musicitems: [MusicItem] = []
    @Published var errors: String = ""
    
    func fetchMusicItems() async {
        var fetchedItems: [MusicItem] = []
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directories = [bundleURL, documentURL]
        
        for directory in directories {
            do {
                let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
                
                for file in files where file.pathExtension.lowercased() == "mp3" {
                    let musicname = file.deletingPathExtension().lastPathComponent
                    let musiccover = await getArtwork(from: file)
                    let musicitem = MusicItem(name: musicname, pth: file, cover: musiccover)
                    fetchedItems.append(musicitem)
                }
                
            } catch {
                errors = error.localizedDescription
            }
        }
        
        musicitems = fetchedItems
    }
}

@MainActor
func getArtwork(from url: URL) async -> UIImage? {
    let asset = AVURLAsset(url: url)
    
    do {
        let formats = try await asset.load(.availableMetadataFormats)
        
        for format in formats {
            let metadataItems = try await asset.load(.metadata)
            
            for item in metadataItems {
                if item.commonKey?.rawValue == "artwork" {
                    if let data = try await item.load(.dataValue) {
                        return UIImage(data: data)
                    }
                }
            }
        }
    } catch {
        print("Failed to load music metadata:", error)
    }
    
    return nil
}
