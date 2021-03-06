////////////////////////////// SMART HOME MODEL SPECIFICATION ///////////////////
abstract sig NodeType {}

sig MobileDevice extends NodeType {}
abstract sig Backend extends NodeType {}
sig ConnectedDevice extends NodeType {
   implements: some ConnectedDeviceCapability
}
sig Cloud extends Backend {}
sig Edge extends Backend {}

enum ConnectedDeviceCapability {GatewayFunctionality, BatterySource, IntegratedSensors, IntegratedActuators, WirelessProtocols, WiredProtocols, CloudServer, API, IFTTT, WebBrowserAccessibility, SmartphoneAccessibility, RemoteAccess}

enum Role {DataSubject, DataController, DataUser}

// Data 
sig Data {
 // is_in: some Context
}

// Context
// sig Context {}

// Location
//sig Location {}

// Nodes
sig Node {
  curates: set Data,
   is: one NodeType//,
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

    all u: User |   
	DataSubject in u.is implies DataController not in u.is && DataUser not in u.is 

    all u: User |   
	DataController in u.is implies DataSubject not in u.is && DataUser not in u.is 

    all u: User |    
	DataUser in u.is implies DataSubject not in u.is && DataController not in u.is 
	
    one u: User | u.is = DataSubject 	
    
     all u: User |   
	DataController in u.is implies MobileDevice not in u.interacts.is      
}

// sample smart home instance
fact "Home setup" {
    one n: Node | n.is = Cloud              	   
    one n: Node | n.is = MobileDevice    	 
    //some n: Node | n.is = ConnectedDevice    
    one c: ConnectedDevice |  c.implements = GatewayFunctionality
    one c: ConnectedDevice |  c.implements = IntegratedActuators
    no Edge
 
    // constraints
    #User = 2
    #Link = 3
    #Data = 2
    #Node = 4
    #ConnectedDevice = 2
}

//////////////////////////////////////////////////////////////////////////////////

// Execute the model
run {} for 4
