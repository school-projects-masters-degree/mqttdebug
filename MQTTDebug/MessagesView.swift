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
    @State private var connectionMessage: String = ""
    
    
    private var groupedMessages: [String: [MQTTSettings.MQTTMessage]] {
        let sortedMessages = mqttSettings.receivedMessages.sorted { $0.timestamp > $1.timestamp }
        let truncatedMessages = sortedMessages.map { message -> MQTTSettings.MQTTMessage in
            let maxLength = 100  // Define a max length
            if message.message.count > maxLength {
                let truncatedMessage = String(message.message.prefix(maxLength)) + "..."
                return MQTTSettings.MQTTMessage(topic: message.topic, message: truncatedMessage, timestamp: message.timestamp, isNew: message.isNew)
            } else {
                return message
            }
        }
        
        // Create a dictionary of grouped messages, limiting to 10 per topic
        return Dictionary(grouping: truncatedMessages, by: { $0.topic }).mapValues { Array($0.prefix(10)) }
    }
    
    
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
                    List(groupedMessages.keys.sorted(), id: \.self) { topic in
                        TopicGroupView(topic: topic, messages: groupedMessages[topic] ?? [], mqttSettings: mqttSettings)
                    }
                }
                
            } else {
                VStack {
                    if !mqttSettings.isConnected || mqttSettings.settingsChanged {
                        // Additional UI components as needed
                    }
                    if mqttSettings.settingsChanged {
                        Text("Settings have changed. Please reconnect.")
                            .foregroundColor(.orange)
                    }
                    
                    Button("Connect") {
                        connectToServer()
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
    private func connectToServer() {
        if mqttSettings.settingsChanged {
            iotManager.disconnect()
            iotManager.connectToServer()
            mqttSettings.settingsChanged = false
        } else {
            iotManager.connectToServer()
        }
        // Add a slight delay to allow the connection process to update the status
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !mqttSettings.isConnected {
                connectionMessage = "Connection failed"
            } else {
                connectionMessage = ""
            }
        }
    }
    
    private func toggleFavoriteStatus(of message: MQTTSettings.MQTTMessage) {
        if let index = mqttSettings.receivedMessages.firstIndex(where: {$0.id == message.id}) {
            mqttSettings.receivedMessages[index].isFavorite.toggle()
            mqttSettings.saveFavoriteMessages()
        }
    }
    
}
/*
 #Preview {
 MessagesView()
 }
 */

