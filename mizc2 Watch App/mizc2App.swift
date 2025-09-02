//
//  mizc2App.swift
//  mizc2 Watch App
//
//  Created by Cindy on 2025/8/27.
//

import SwiftUI
import WatchConnectivity

@main
struct mizc2_Watch_AppApp: App {
    @State private var wsSession = WatchSessionManager()
    
    init () {
        if WCSession.isSupported() {
            print("激活成功")
            WCSession.default.delegate = wsSession
            WCSession.default.activate()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(wsSession)
    }
}
