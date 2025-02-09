//
//  ContentView.swift
//  HomeKitAdapter
//
//  Created by Julian Kahnert on 11.01.25.
//

import DistributedCluster
import SwiftUI
import Shared

var actorSystem: ClusterSystem!
var actor: HomeCommandHandler!

struct ContentView: View {
    var body: some View {
        HStack {
            Button("Connect") {
                Task {
                    // MARK: - Step 5
                    actorSystem.cluster.join(host: "0.0.0.0", port: 8888)
                    try await actorSystem.cluster.joined(within: .seconds(2))
                    print("******** join called")
                }
            }
            
            Button("Send event") {
                Task {
                    // MARK: - Step 6
                    let serverActor = await actorSystem!.receptionist.lookup(.homeEventHandler).first!
                    do {
                        print("******** send start \(Date().ISO8601Format(.init(includingFractionalSeconds: true)))")
                        // MARK: - Step 7
                        try await serverActor.handle(event: "Hello from App!")
                        print("******** send success")
                    } catch {
                        print("******** send failed \(error)")
                    }
                }
            }
        }
        .task {
            
            // MARK: - Step 3
            var settings = ClusterSystemSettings(name: "HomeAutomation-App", host: "0.0.0.0", port: 7777)
            // uncomment when you want to use ServiceDiscovery
            //settings.discovery = ServiceDiscoverySettings(static: [.init(host: "0.0.0.0", port: 7777), .init(host: "0.0.0.0", port: 8888)])
            actorSystem = await ClusterSystem("HomeAutomation-App", settings: settings)
            
            // MARK: - Step 4
            actor = HomeCommandHandler(actorSystem: actorSystem)
            await actorSystem.receptionist.checkIn(actor, with: .homeCommandHandler)

            Task {
                for await event in actorSystem.cluster.events {
                    print("******** event \(event)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
