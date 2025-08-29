//
//  Manager.swift
//  mizc2
//
//  Created by Cindy on 2025/8/28.
//

import SwiftUI
import UniformTypeIdentifiers
import WatchConnectivity
import Combine

class iPhoneMP3Manager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = iPhoneMP3Manager()
    
    @Published var mp3Files: [URL] = []

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        loadMP3Files()
    }
    
    func loadMP3Files() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            mp3Files = try FileManager.default.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension.lowercased() == "mp3" }
        } catch {
            print("加载本地 MP3 失败:", error)
        }
    }
    
    func importMP3Files(urls: [URL]) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        for url in urls {
            let dest = documents.appendingPathComponent(url.lastPathComponent)
            if !FileManager.default.fileExists(atPath: dest.path) {
                do {
                    try FileManager.default.copyItem(at: url, to: dest)
                } catch {
                    print("导入失败:", error)
                }
            }
        }
        loadMP3Files()
    }
    
    func sendAllMP3ToWatch() {
        let session = WCSession.default
        guard session.activationState == .activated else {
            print("WCSession 未激活")
            return
        }
        for file in mp3Files {
            session.transferFile(file, metadata: ["fileName": file.lastPathComponent])
            print("已发送到手表:", file.lastPathComponent)
        }
    }

    // MARK: - WCSessionDelegate 必须实现
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
}
