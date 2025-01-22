// The Swift Programming Language
// https://docs.swift.org/swift-book

import Shared
import DistributedCluster
//import WebSocketActors

@main
struct Main {
    static func main() async throws {
        
        let system = await ClusterSystem("HomeAutomation-Server", settings: .init(name: "HomeAutomation-Server", host: "0.0.0.0", port: 7117))
//        let system = await ClusterSystem("Node-A") { settings in
//            settings.bindPort = 7227
//            settings.logging.logLevel = .debug
//            settings.onDownAction = .gracefulShutdown(delay: .seconds(10))
////            settings.plugins.install(plugin: .)
//        }
        
//        let node = Cluster.Node(host: "0.0.0.0", port: 7117)
//        system.cluster.join(node: node)
//        try await system.cluster.waitFor(node, .up, within: .seconds(10))
//        system.cluster.join(host: "0.0.0.0", port: 7117)
        
        let actor = HomeKitAdapter(actorSystem: system)
        await system.receptionist.checkIn(actor, with: .homeKitAdater)
        
        
        try await Task.sleep(for: .seconds(10))
        let eventHandler = await system.receptionist.lookup(.homeEventHandler).first!
        Task {
            do {
                try await eventHandler.handle(event: "event 1")
                try await Task.sleep(for: .seconds(1))
                
                try await eventHandler.handle(event: "event 2")
                try await Task.sleep(for: .seconds(1))
                
                try await eventHandler.handle(event: "event 3")
            } catch {
                print(error)
            }
        }
        
        print("Server Running")
        

        try await system.terminated
    }
}
