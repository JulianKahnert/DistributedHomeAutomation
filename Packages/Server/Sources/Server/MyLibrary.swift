// The Swift Programming Language
// https://docs.swift.org/swift-book

import Shared
import WebSocketActors

@main
struct Main {
    static func main() async throws {
        
        let address = ServerAddress(scheme: .insecure, host: "localhost", port: 8888)
        let system = WebSocketActorSystem(id: .server)
        try await system.runServer(at: address)
        
//        let homeKitAdapter = HomeKitAdapter(actorSystem: system)

        _ = system.makeLocalActor(id: .homeKitAdater) {
            HomeKitAdapter(actorSystem: system)
//            homeKitAdapter
        }
        
        let eventHandler = try HomeEventHandler.resolve(id: .eventHandler, using: system)
//        Task {
//            try! await eventHandler.handle(event: "event 1")
//            try await Task.sleep(for: .seconds(1))
//            
//            try! await eventHandler.handle(event: "event 2")
//            try await Task.sleep(for: .seconds(1))
//            
//            try! await eventHandler.handle(event: "event 3")
//            
//        }
        
        print("Server Running")
        
        while true {
           try await Task.sleep(for: .seconds(1_000_000))
        }
    }
}
