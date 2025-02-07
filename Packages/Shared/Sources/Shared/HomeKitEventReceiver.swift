//
//  HomeKitEventReceiver.swift
//  Shared
//
//  Created by Julian Kahnert on 31.01.25.
//

import Distributed
import WebSocketActors

extension NodeIdentity {
    public static let server = NodeIdentity(id: "server")
}

extension ActorIdentity {
    public static let homeKitEventReceiver = ActorIdentity(id: "homeKitEventReceiver", node: .server)
}


public protocol Test : DistributedActor {
    func process(event: String) -> Bool
}

/// Receiver of HomeKitEvents
///
/// This should be instantiated on the server.
public distributed actor HomeKitEventReceiver: Test {
    public typealias ActorSystem = WebSocketActorSystem
    
    private var eventStream: AsyncStream<String>.Continuation?
    
    public init(eventStream: AsyncStream<String>.Continuation, actorSystem: ActorSystem) {
        self.actorSystem = actorSystem
        self.eventStream = eventStream
    }
    
    /// process  an incoming HomeKit event
    ///
    /// return: true when processing was successfull
    @discardableResult
    public distributed func process(event: String) -> Bool {
        guard let eventStream else { return false }
        eventStream.yield(event)
        return true
    }
}

extension HomeKitEventReceiver {
    public struct Event: Codable, Sendable {
        public let type: String
        public let payload: [String: String]
        
        public init(type: String, payload: [String: String]) {
            self.type = type
            self.payload = payload
        }
    }
}
