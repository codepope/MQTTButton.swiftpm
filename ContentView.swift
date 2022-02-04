import SwiftUI
import SwiftMQTT

struct ContentView: View {
    @State private var state=false
        
    func setState(newState: Bool) {
        mqttSession.username="mutesync"
        mqttSession.password="mutesync"
        mqttSession.connect {error in
            if error == .none {
                let json=["mute":state]
                let data=try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                let topic="dnd/state"
                mqttSession.publish(data, in: topic, delivering: .atLeastOnce, retain: false) { error in
                    if error == .none {
                        print("Published in \(topic)")
                    } else {
                        print(error.description)
                    }
                }
            } else {
                print(error.description)
            }
        }
    }
    
    var mqttSession=MQTTSession(
        host:"jonah.local",
        port:1883,
        clientID:"MQTTButton",
        cleanSession:true,
        keepAlive: 15,
        useSSL: false)
    
    var body: some View {
        GroupBox() {
            Toggle("Muting",isOn: $state).onChange(of: state) {
                newValue in
                setState(newState: newValue)
            }
            
        } label: {
            Text("Controls")
        } 
        
    }
}

