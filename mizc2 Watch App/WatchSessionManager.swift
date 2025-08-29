//
//  WatchSessionManager.swift
//  mizc2
//
//  Created by Cindy on 2025/8/28.
//

import WatchConnectivity
import SwiftUI
import Combine

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
    
    // 接收 iPhone 发送的 MP3
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dest = documents.appendingPathComponent(file.fileURL.lastPathComponent)
        do {
            try FileManager.default.moveItem(at: file.fileURL, to: dest)
            print("收到 MP3:", file.fileURL.lastPathComponent)
            // 你已有读取列表的代码，这里不做 UI 刷新
        } catch {
            print("保存失败:", error)
        }
    }
    
    // WCSessionDelegate 必须方法
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
