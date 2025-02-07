//
//  HomeKitCommandReceiver.swift
//  Shared
//
//  Created by Julian Kahnert on 31.01.25.
//

import Distributed
import WebSocketActors

extension NodeIdentity {
    public static let homeKitAdapter = NodeIdentity(id: "homeKitAdapter")
}

extension ActorIdentity {
    public static let homeKitCommandReceiver = ActorIdentity(id: "homeKitCommandReceiver", node: .homeKitAdapter)
}


/// Receiver of HomeKit commands
///
/// This should be instantiated on the HomeKitAdapter.
public distributed actor HomeKitCommandReceiver {
    public typealias ActorSystem = WebSocketActorSystem
    
    private var eventStream: AsyncStream<Command>.Continuation?
    
    public init(eventStream: AsyncStream<Command>.Continuation, actorSystem: ActorSystem) {
        self.actorSystem = actorSystem
        self.eventStream = eventStream
    }
    
    /// process  an incoming HomeKit command, e.g. "turn light on"
    ///
    /// return: true when processing was successfull
    @discardableResult
    public distributed func process(command: Command) -> Bool {
        guard let eventStream else { return false }
        eventStream.yield(command)
        return true
    }
}

extension HomeKitCommandReceiver {
    public struct Command: Codable, Sendable {
        public let action: String
        public let parameters: [String: String]
        
        public init(action: String, parameters: [String: String]) {
            self.action = action
            self.parameters = parameters
        }
    }
}
