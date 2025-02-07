//
//  ContentView.swift
//  HomeKitAdapter
//
//  Created by Julian Kahnert on 11.01.25.
//

import SwiftUI
import Shared
import WebSocketActors

let address = ServerAddress(scheme: .insecure, host: "localhost", port: 8888)
let webSocketActorSystem = WebSocketActorSystem(id: .homeKitAdapter)

struct ContentView: View {
    var body: some View {
        HStack {
            Button {
                Task {
                    let receiver = try HomeKitEventReceiver.resolve(id: .homeKitEventReceiver, using: webSocketActorSystem)
                    
                    _ = try! await receiver.process(event: "catalyst")
                }
            } label: {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                .padding()
            }
            Button("Shutdown") {
                Task {
                    await webSocketActorSystem.shutdownGracefully()
                }
            }
            .task {
                try! await webSocketActorSystem.connectClient(to: address)
            }
        }
    }
}

#Preview {
    ContentView()
}
