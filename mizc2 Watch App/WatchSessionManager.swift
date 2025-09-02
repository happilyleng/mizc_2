//
//  WatchSessionManager.swift
//  mizc2
//
//  Created by Cindy on 2025/8/28.
//

import WatchConnectivity
import SwiftUI
import Combine

@Observable
class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dest = documents.appendingPathComponent(file.fileURL.lastPathComponent)
        do {
            try FileManager.default.moveItem(at: file.fileURL, to: dest)
            print("收到 MP3:", file.fileURL.lastPathComponent)
        } catch {
            print("保存失败:", error)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Watch端 WCSession 激活失败: \(error)")
        } else {
            print("Watch端 WCSession 激活成功，状态: \(state.rawValue)")
        }
    }
}
