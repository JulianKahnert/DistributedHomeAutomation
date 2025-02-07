// The Swift Programming Language
// https://docs.swift.org/swift-book

import Shared
import WebSocketActors

@MainActor
final class System {
    
    static let shared = System()
    
    private let webSocketActorSystem = WebSocketActorSystem(id: .server)
    private var manager: ClientManager?
    private var actor: HomeKitEventReceiver?
    
    private init() {}
    
    func test() -> HomeKitEventReceiver {
        if let actor {
            return actor
        }
        
        let stream = AsyncStream<String>.makeStream(of: String.self)

        let actor = webSocketActorSystem.makeLocalActor(id: .homeKitEventReceiver) {
            HomeKitEventReceiver(eventStream: stream.continuation, actorSystem: webSocketActorSystem)
        }
        
        Task {
            for await event in stream.stream {
                print("received event \(event)")
            }
        }
        
        self.actor = actor
        return actor
    }
  
    func start(host: String, port: Int) async throws {
        await manager?.cancel()
        
        let address = ServerAddress(scheme: .insecure, host: host, port: port)
        try await webSocketActorSystem.runServer(at: address)
        
        _ = test()
    }
}


@main
struct Main {
    static func main() async throws {
        
        try await System.shared.start(host: "localhost", port: 8888)
        let adapter = System.shared.test()

        print("Server Running")
        
        var index = 0
        while true {
           try await Task.sleep(for: .seconds(10))
            
            index += 1
            print("Sending event")
            _ = try! await adapter.process(event: "server \(index)")
        }
    }
}
