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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("进入 WCSessionDelegateImpl 的 session 方法")
        // 处理从 WatchOS 接收到的消息
        if let message = message["msg"] as? [[String: Any]] {
            print("接收到 \(message)")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if state == .activated {
            print("Watch端 WCSession 激活成功")
        } else {
            print("Watch端 WCSession 激活失败: \(String(describing: error))")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession 会话变为非活跃.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession 会话被停用.")
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
}
