//
//  MQTTSettings.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 16.11.23.
//

import Foundation

class MQTTSettings: ObservableObject {
    
    @Published var receivedMessages: [MQTTMessage] = []
    
    @Published var brokerIP: String = "10.55.200.203"
    @Published var portNumber: Int = 1883 // Default port
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var topic: String = "#"
    @Published var isConnected: Bool = false
    @Published var connectionError: String?
    @Published var settingsChanged = false
    
    struct MQTTMessage: Identifiable {
        // Identify by UUID
        let id = UUID()
        let topic: String
        let message: String
        let timestamp: Date
    }
    
}
