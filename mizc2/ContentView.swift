//
//  ContentView.swift
//  mizc2
//
//  Created by Cindy on 2025/8/27.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    var body: some View {
        iPhoneMP3View()
        .padding()
    }
}

struct iPhoneMP3View: View {
    @StateObject var manager = iPhoneMP3Manager.shared
    @State private var showDocumentPicker = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if manager.mp3Files.isEmpty {
                        Text("没有 MP3 文件")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(manager.mp3Files, id: \.self) { file in
                            Text(file.lastPathComponent)
                        }
                    }
                }
                
                HStack {
                    Button("添加 MP3") {
                        showDocumentPicker = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("发送全部") {
                        manager.sendAllMP3ToWatch()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .navigationTitle("iPhone MP3")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fileImporter(
            isPresented: $showDocumentPicker,
            allowedContentTypes: [UTType.mp3],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                manager.importMP3Files(urls: urls)
            case .failure(let error):
                print("选择失败:", error.localizedDescription)
            }
        }
    }
}
