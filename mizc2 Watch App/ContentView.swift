//
//  ContentView.swift
//  mizc2 Watch App
//
//  Created by Cindy on 2025/8/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            NavigationStack {
                MusicListMainView()
            }
        }
        .foregroundStyle(Color.pink)
    }
}

#Preview {
    ContentView()
}
