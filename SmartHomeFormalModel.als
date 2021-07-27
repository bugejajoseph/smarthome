////////////////////////////// SMART HOME MODEL SPECIFICATION ///////////////////
abstract sig NodeType {}

sig MobileDevice extends NodeType {}
abstract sig Backend extends NodeType {}
sig ConnectedDevice extends NodeType {
     implements: some ConnectedDeviceCapability
}
sig Cloud extends Backend {}
sig Edge extends Backend {}

abstract sig Role {}
one sig DataSubject, DataController, DataUser extends Role {}

abstract sig ConnectedDeviceCapability {} 
one sig GatewayFunctionality, BatterySource, IntegratedSensors, IntegratedActuators, WirelessProtocols, WiredProtocols, CloudServer, API, IFTTT, WebBrowserAccessibility, SmartphoneAccessibility, RemoteAccess extends ConnectedDeviceCapability {}

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
    
     all u: User |   
	DataController in u.is implies MobileDevice not in u.interacts.is      
}



////////////////////////////// SMART HOME MODEL INSTANTIATION ///////////////////
sig ConnectedToy extends ConnectedDevice {}
sig VideoDoorbell extends ConnectedDevice {}
sig Parent, Child, ServiceProvider extends User {}

fact "Home setup" {
    // Nodes and their capabilities
    one n: Node | n.is = Cloud      	   
    one n: Node | n.is = MobileDevice       	 
    one n: Node | n.is = ConnectedToy && n.is.implements = IntegratedSensors + IntegratedActuators + BatterySource + WirelessProtocols + CloudServer 
    one n: Node | n.is = VideoDoorbell  && n.is.implements = IntegratedSensors + IntegratedActuators + BatterySource + WirelessProtocols + RemoteAccess + GatewayFunctionality + SmartphoneAccessibility + IFTTT    

    // Users and their roles
    one u1:Child | u1.interacts.is = ConnectedToy && u1.is = DataSubject 
    one u2:Parent | u2.interacts.is = VideoDoorbell + MobileDevice && u2.is = DataSubject
    one u3:ServiceProvider | u3.interacts.is = Cloud && u3.is = DataController 

    no Edge
     
    no Data // for diagram's sake
    // constraints
    #User = 3
    #Link = 4
    #Node = 4
}

//////////////////////////////////////////////////////////////////////////////////

// Execute the model
run {} for 4
