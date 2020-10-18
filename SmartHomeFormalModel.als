////////////////////////////// SMART HOME MODEL SPECIFICATION ///////////////////
abstract sig NodeType {}
sig ConnectedDevice, MobileDevice, Gateway, Backend extends NodeType {}
sig Cloud extends Backend {}

enum Capability {Storage, Processing, RemoteAdmin}
enum Role {Owner, Family, Guest}

//abstract sig Context {}

// Data 
sig Data {
 // is_in: some Context
}

// Location
//sig Location {}

// Nodes
sig Node {
  curates: set Data,
  is: one NodeType,
  implements: some Capability
  //deployed: one Location
}

// Users
sig User {
   interacts: set Node,
   is: some Role,
   generates: set Data,
//   assigned: set Context 
}

// Links
sig Sender in Node+User{}
sig Receiver in Node{}
sig Link {
  from: one Sender,
  to: one Receiver,
  transfer: set Data
}

// Facts
fact "Policy" {
    all x: Link | x.from != x.to  // no links from a host to itself

    all u: User |    // user cannot be both a guest and an owner or have family role
	Guest in u.is implies Owner not in u.is && Family not in u.is 
}

fact "Home setup" {
    one n: Node | n.is = Cloud              	   // there must be a cloud
    one n: Node | n.is = MobileDevice    	   // there must be a mobile device
    one n: Node | n.is = ConnectedDevice    // there must be a connected device
    one n: Node | n.is = Gateway    		   // there must be a gateway device
 
    // constraints
    #User = 2
    #Link = 3
    #Data = 2
}

//////////////////////////////////////////////////////////////////////////////////

// Execute the model
run {} for 4
