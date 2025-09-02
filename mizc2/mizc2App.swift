//
//  mizc2App.swift
//  mizc2
//
//  Created by Cindy on 2025/8/27.
//

import SwiftUI
import WatchConnectivity

@main
struct mizc2App: App {
    @State private var wcSession = iPhoneMP3Manager()
    
    init() {
        if WCSession.isSupported() {
            print("当前设备支持 WCSession 。")
            WCSession.default.delegate = wcSession
            WCSession.default.activate()
        } else {
            print("当前设备不支持 WCSession.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
