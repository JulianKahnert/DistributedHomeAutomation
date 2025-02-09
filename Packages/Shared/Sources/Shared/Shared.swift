//
//  Shared.swift
//  Shared
//
//  Created by Julian Kahnert on 11.01.25.
//

import Distributed
import DistributedCluster
import Foundation

typealias DefaultDistributedActorSystem = ClusterSystem

public extension DistributedReception.Key {
    static var homeCommandHandler: DistributedReception.Key<HomeCommandHandler> {
        "homeCommandHandler"
    }
    static var homeEventHandler: DistributedReception.Key<HomeEventHandler> {
        "homeEventHandler"
    }
}

public distributed actor HomeCommandHandler {
    public distributed func handle(command: String) {
        print("******** Handling command: \(command) \(Date().ISO8601Format(.init(includingFractionalSeconds: true)))")
    }
}

public distributed actor HomeEventHandler {
    public distributed func handle(event: String) async {
        print("******** Receiving event that will be handled: \(event) \(Date().ISO8601Format(.init(includingFractionalSeconds: true)))")
        
        // MARK: - Step 8
        let appActor = await actorSystem.receptionist.lookup(.homeCommandHandler).first!
        // MARK: - Step 9
        try! await appActor.handle(command: "*** ACK ***")
    }
}
