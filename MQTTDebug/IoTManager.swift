//
//  IoTManager.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 11.11.23.
//

import Foundation
import CocoaMQTT

class IoTManager: CocoaMQTTDelegate {
    
    var mqtt: CocoaMQTT!
    
    init(clientID: String,
         serverURL: String,
         serverPort: UInt16 = 1883
    ) {
        
        let clientID = "MQTTDebugger"
        //let serverURL = "10.55.202.36"
        let serverURL = "10.55.200.123"
        let serverPort: UInt16 = 1883 // or the port specified by your IoT device
        
        mqtt = CocoaMQTT(clientID: clientID, host: serverURL, port: serverPort)
        mqtt.delegate = self
        mqtt.username = "ben"
        mqtt.password = "1234"
        mqtt.allowUntrustCACertificate = true
        
        mqtt.connect()
        mqtt.subscribe("/*")
    }
    
    
    // MARK: - CocoaMQTTDelegate methods
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            print("Connected to the IoT device!")
            // Perform actions after successful connection
        } else {
            print("Failed to connect to the IoT device")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Data published successfully")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        if let messageString = message.string {
            print("Received message on topic \(message.topic): \(messageString)")
            // Process the received message
            
            // TODO: Save messages persistentenantly
            
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didDisconnectWithError error: Error?) {
       if let error = error {
           print("Disconnected from the IoT device with error: \(error.localizedDescription)")
       } else {
           print("Disconnected from the IoT device")
       }
   }
    
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublish ACK")
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("didSubscribeTopics")
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("didUnsubscribeTopics")
    }
    
    ///
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("Ping")
    }
    
    ///
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("Pong")
    }
    
    ///
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("Did Disconnect \(String(describing: err))")
    }
}

extension IoTManager {
    func subscribeToTopic(topic: String) {
        mqtt.subscribe(topic)
    }

    func publishData(topic: String, message: String) {
        mqtt.publish(topic, withString: message, qos: .qos1)
    }
}
