//
//  Shared.swift
//  Shared
//
//  Created by Julian Kahnert on 11.01.25.
//

// Shared.swift
import Distributed

public struct HomeKitEvent: Codable {
    public let type: String
    public let payload: [String: String]
    
    public init(type: String, payload: [String: String]) {
        self.type = type
        self.payload = payload
    }
}

public struct Command: Codable {
    public let action: String
    public let parameters: [String: String]
    
    public init(action: String, parameters: [String: String]) {
        self.action = action
        self.parameters = parameters
    }
}

// TODO: delete this
import WebSocketActors

extension NodeIdentity {
    public static let server = NodeIdentity(id: "server")
    public static let node = NodeIdentity(id: "node")
}

extension ActorIdentity {
    public static let homeKitAdater = ActorIdentity(id: "homeKitAdater", node: .server)
    public static let eventHandler = ActorIdentity(id: "eventHandler", node: .node)
}

public distributed actor HomeKitAdapter {
    public typealias ActorSystem = WebSocketActorSystem
    
    public distributed func greet(name: String) -> String {
        return "Hello, \(name)!"
    }
   
    public distributed func handle(command: String) {
        print("Handling command: \(command)")
    }
//    public distributed func getEvents(handles: () -> Void) -> String {
//        return "Hello, \(name)!"
//    }
}

public distributed actor HomeEventHandler {
    public typealias ActorSystem = WebSocketActorSystem
    
    public distributed func handle(event: String) {
        print("Receiving event that will be handled: \(event)")
    }
}
