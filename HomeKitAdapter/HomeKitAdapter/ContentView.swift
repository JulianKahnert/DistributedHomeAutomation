//
//  ContentView.swift
//  HomeKitAdapter
//
//  Created by Julian Kahnert on 11.01.25.
//

import SwiftUI
import Shared

let address = ServerAddress(scheme: .insecure, host: "localhost", port: 8888)
let webSocketActorSystem = WebSocketActorSystem(id: .node)

struct ContentView: View {
    var body: some View {
        HStack {
            Button {
                Task {
                    do {
                        try await runLoop()
                    } catch {
                        print(error)
                    }
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
        }
        .task {
            
            
            try! await webSocketActorSystem.connectClient(to: address)
            
            _ = webSocketActorSystem.makeLocalActor(id: .eventHandler) {
                HomeEventHandler(actorSystem: webSocketActorSystem)
            }
        }
    }
}

import WebSocketActors
func runLoop() async throws {
    
    // TODO: there should be something that tries to start a connection
//    try! await webSocketActorSystem.connectClient(to: address)

    let greeter = try HomeKitAdapter.resolve(id: .homeKitAdater, using: webSocketActorSystem)
    let greeting = try await greeter.greet(name: "Alice")
    print(greeting)
    
    try await greeter.handle(command: "test 1")
//    try await Task.sleep(for: .seconds(1))
//    
//    try await greeter.handle(command: "test 2")
//    try await Task.sleep(for: .seconds(1))
//
//    try await greeter.handle(command: "test 3")
//    try await Task.sleep(for: .seconds(1))
}

#Preview {
    ContentView()
}
