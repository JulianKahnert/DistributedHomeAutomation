// The Swift Programming Language
// https://docs.swift.org/swift-book

import Shared
import DistributedCluster

@main
struct Main {
    static func main() async throws {
        
        // MARK: - Step 1
        var settings = ClusterSystemSettings(name: "HomeAutomation", host: "0.0.0.0", port: 8888)
        // uncomment when you want to use ServiceDiscovery
        //settings.discovery = ServiceDiscoverySettings(static: [.init(host: "0.0.0.0", port: 7777), .init(host: "0.0.0.0", port: 8888)])
        let system = await ClusterSystem("HomeAutomation", settings: settings)
        
        // MARK: - Step 2
        let actor = HomeEventHandler(actorSystem: system)
        await system.receptionist.checkIn(actor, with: .homeEventHandler)
        
        Task {
            for await event in system.cluster.events {
                print("******** event \(event)")
            }
        }
        
        print("******** Server Running")
        try await system.terminated
        print("******** Server stopped")
    }
}
