//
//  ContentView.swift
//  HomeKitAdapter
//
//  Created by Julian Kahnert on 11.01.25.
//

import DistributedCluster
import SwiftUI
import Shared

var globalSystem: ClusterSystem?

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
            Button("Connect") {
                Task {
                    globalSystem!.cluster.join(host: "0.0.0.0", port: 7117)
                }
            }
        }
        .task {
            
            let system = await ClusterSystem("HomeAutomation-Server", settings: .init(name: "HomeAutomation-Server", host: "0.0.0.0", port: 7227))
            system.cluster.join(host: "0.0.0.0", port: 7117)

            let actor = HomeEventHandler(actorSystem: system)
            await system.receptionist.checkIn(actor, with: .homeEventHandler)
            
            globalSystem = system
        }
    }
}

import WebSocketActors
func runLoop() async throws {
    
//    let system = await ClusterSystem("HomeAutomation-Server", settings: .init(name: "HomeAutomation-Server", host: "0.0.0.0", port: 7227))
//    system.cluster.join(host: "0.0.0.0", port: 7117)
//
//    let actor = HomeEventHandler(actorSystem: system)
//    await system.receptionist.checkIn(actor, with: .homeEventHandler)
//    
//    try await Task.sleep(for: .seconds(1))
    
    let system = globalSystem!
    
    let greeter = await system.receptionist.lookup(.homeKitAdater).first!
    
    let greeting = try await greeter.greet(name: "Alice")
    print(greeting)
    
    try await greeter.handle(command: "test 1")
    try await Task.sleep(for: .seconds(1))
    
    try await greeter.handle(command: "test 2")
    try await Task.sleep(for: .seconds(1))

    try await greeter.handle(command: "test 3")
    try await Task.sleep(for: .seconds(1))
}

#Preview {
    ContentView()
}
