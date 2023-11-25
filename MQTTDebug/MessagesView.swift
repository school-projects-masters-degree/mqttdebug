//
//  MessagesView.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 21.10.23.
//

import SwiftUI
import CocoaMQTT
struct MessagesView: View {

    @ObservedObject var mqttSettings = MQTTSettings()
    @StateObject private var iotManager: IoTManager
    
    init(mqttSettings: MQTTSettings) {
        self.mqttSettings = mqttSettings
        _iotManager = StateObject(wrappedValue: IoTManager(mqttSettings: mqttSettings))
    }
    var body: some View {
        VStack {
            if mqttSettings.isConnected {
                if mqttSettings.receivedMessages.isEmpty {
                    Text("No messages received")
                } else {
                    List(mqttSettings.receivedMessages) { message in
                        VStack(alignment: .leading) {
                            
                            Text("Topic: \(message.topic)")
                                .fontWeight(.bold)
                            Text("\(message.message)")
                            Text("Received at: \(message.timestamp.formatted())")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                
            } else {
                
                VStack {
                    if !mqttSettings.isConnected || mqttSettings.settingsChanged {
                        
                    }
                    if mqttSettings.settingsChanged {
                        Text("Settings have changed. Please reconnect.")
                            .foregroundColor(.orange)
                    }
                    
                    Button("Connect") {
                        if mqttSettings.settingsChanged {
                            iotManager.disconnect()
                            iotManager.connectToServer()
                            mqttSettings.settingsChanged = false
                        } else {
                            iotManager.connectToServer()
                        }
                    }.buttonStyle(.bordered)
                        .fontWeight(.bold)
                    
                    Text("matching every topic by default")
                        .foregroundColor(.gray)
                }
                
                
                if let connectionError = mqttSettings.connectionError {
                    Text(connectionError)
                        .foregroundColor(.red)
                }
            }
        }
        
    }
    
    
}
/*
#Preview {
    MessagesView()
}
 */

