# DistributedHomeAutomation

This project serves as an example for [this blogpost](https://juliankahnert.de/posts/2025-02-09--swift-distributed-actors/).

The steps in this sequence diagramm can be found by looking for the `// MARK: - Step ` annotation in this project.

```mermaid
sequenceDiagram
    autonumber
    participant Node1 as Server
    participant Node2 as App

    Node1->>+Node1: await ClusterSystem("0.0.0.0:8888")
    Node1->>+Node1: receptionist.checkIn()
    Node2->>+Node2: await ClusterSystem("0.0.0.0:7777")
    Node2->>+Node2: receptionist.checkIn()
    Node2->>+Node2: cluster.join(endpoint: "0.0.0.0:8888")
    Node2->>+Node2: receptionist.lookUp(serverActor)
    Node2->>Node1: serverActor.handle(event:)
    Node1->>+Node1: receptionist.lookUp(appActor)
    Node1->>Node2: appActor.send
```
