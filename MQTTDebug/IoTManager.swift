//
//  IoTManager.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 11.11.23.
//

import Foundation
import CocoaMQTT

class IoTManager: NSObject,ObservableObject, CocoaMQTTDelegate  {
    
    var mqtt: CocoaMQTT!
    @Published var mqttSettings: MQTTSettings
    let clientID = "MQTTDebugger-" + String(ProcessInfo().processIdentifier)
    
    init(mqttSettings: MQTTSettings) {
        self.mqttSettings = mqttSettings
        super.init()
        let clientID = clientID
        //let serverURL = "10.55.202.36"
        let serverURL = mqttSettings.brokerIP
        guard (0...65535).contains(mqttSettings.portNumber) else {
            mqttSettings.connectionError = "Invalid Port Number"
            return
        }
        let serverPort = UInt16(mqttSettings.portNumber)
        
        mqtt = CocoaMQTT(clientID: clientID, host: serverURL, port: serverPort)
        mqtt.delegate = self
        //mqtt.username = "ben"
        //mqtt.password = "1234"
       // mqtt.allowUntrustCACertificate = true
        
        //mqtt.connect()
    }
    
    // TODO: Trigger reconnect upon change
    func configure(clientID: String, serverURL: String, serverPort: UInt16, username:String?, password: String?){
        mqtt.host = serverURL
        // Port is already validated, no need to check
        
        mqtt.port = serverPort
        mqtt.username = username
        mqtt.password = password
    }
    
    func connectToServer() {
        guard !mqttSettings.brokerIP.isEmpty else {
            mqttSettings.connectionError = "Broker IP is empty"
            return
        }
     
        guard (0...65535).contains(mqttSettings.portNumber) else {
            mqttSettings.connectionError = "Invalid Port Number"
            return
        }
        mqtt = CocoaMQTT(clientID: clientID, host: mqttSettings.brokerIP, port: UInt16(mqttSettings.portNumber))
        mqtt.delegate = self
        mqtt.username = mqttSettings.username
        mqtt.password = mqttSettings.password
        mqtt.subscribe(mqttSettings.topic)
        mqtt.allowUntrustCACertificate = true
        let connectionSuccess = mqtt.connect()
        if !connectionSuccess {
            mqttSettings.connectionError = "Failed to initiate connection"
            mqttSettings.isConnected = false
        }
        }

    func disconnect() {
        mqtt.disconnect()
        mqttSettings.isConnected = false
        mqttSettings.connectionError = "Not Connected, Please check your settings."
        mqttSettings.saveFavoriteMessages()
    }

    // MARK: - CocoaMQTTDelegate methods
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            print("Connected to the IoT device!")
            mqttSettings.isConnected = true
            mqttSettings.connectionError = nil
            mqttSettings.synchronizeFavoriteMessages()
            // Delay Subscription
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.mqtt.subscribe(self.mqttSettings.topic)
            }
        } else {
            print("Failed to connect to the IoT device")
            mqttSettings.isConnected = false
            mqttSettings.connectionError = "Failed to connect to the MQTT Broker"
        }

    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Data published successfully")
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("didSubscribeTopics")
        print("Subscribed to topics \(self.mqttSettings.topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
      if let messageString = message.string {
            print("Received message on topic \(message.topic): \(messageString)")
            // Process the received message
            
          let mqttMessage = MQTTSettings.MQTTMessage(topic: message.topic, message: messageString, timestamp: Date(), isNew: true
          )
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.mqttSettings.receivedMessages.append(mqttMessage)
                print("Message appended: \(messageString)")
            }
            
        } else {
            print("Received a message but could not decode the string.")
        }
    }
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublish ACK")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didDisconnectWithError error: Error?) {
       if let error = error {
           print("Disconnected from the IoT device with error: \(error.localizedDescription)")
           mqttSettings.connectionError = error.localizedDescription
       } else {
           print("Disconnected from the IoT device")
           mqttSettings.connectionError = "Disconnected from the MQTT broker."
       }
        mqttSettings.isConnected = false
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
        mqttSettings.isConnected = false
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
