//
//  HomeKitAdapter.swift
//  Shared
//
//  Created by Julian Kahnert on 11.01.25.
//

import Distributed
import WebSocketActors

//public distributed actor HomeKitAdapter {
//    public typealias ActorSystem = WebSocketActorSystem
//
//    init(actorSystem: ActorSystem) {
//        self.actorSystem = actorSystem
//    }
//    
//    public distributed func handle(command: Command) async throws {
//        print("Command empfangen: \(command.action) mit Parametern: \(command.parameters)")
//        if command.action == "LightOn" {
//            print("Licht wird eingeschaltet")
//        } else {
//            print("Unbekanntes Command: \(command.action)")
//        }
//    }
//
//    func sendEvent(type: String, payload: [String: String]) async {
//        let event = HomeKitEvent(type: type, payload: payload)
//        do {
////            let server = try await actorTransport.resolve(
////                id: .init(protocol: "ws", host: "localhost", port: 8080, id: "event-server"),
////                as: EventServer.self
////            )
////            try await server.receive(event: event)
//        } catch {
//            print("Fehler beim Senden des Events: \(error)")
//        }
//    }
//}
