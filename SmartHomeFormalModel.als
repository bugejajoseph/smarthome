////////////////////////////// SMART HOME MODEL SPECIFICATION ///////////////////
abstract sig NodeType {}
sig ConnectedDevice, MobileDevice, Gateway, Backend extends NodeType {}
sig Cloud extends Backend {}

//enum Capability {Storage, Processing, RemoteAdmin}

enum Capability {GatewayFunctionality, BatterySource, IntegratedSensors, IntegratedActuators, WirelessProtocols, WiredProtocols, CloudServer, API, IFTTT, WebBrowserAccessibility, SmartphoneAccessibility, RemoteAccess}

enum Role {DataSubject, DataController, DataUser}
//enum Role {Owner, Family, Guest}

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

    // make each role exclusive
    all u: User |   
	DataSubject in u.is implies DataController not in u.is && DataUser not in u.is 

    all u: User |   
	DataController in u.is implies DataSubject not in u.is && DataUser not in u.is 

    all u: User |    
	DataUser in u.is implies DataSubject not in u.is && DataController not in u.is 

    // limit number of capabilities to 3 (for simplicity)
    all n: Node |
	#n.implements <= 3  
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
