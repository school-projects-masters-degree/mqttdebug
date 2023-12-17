//
//  ConnectionStatusView.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 21.10.23.
//

import SwiftUI

struct ConnectionStatusView: View {
    @ObservedObject var mqttSettings = MQTTSettings()
    @ObservedObject var iotManager: IoTManager
    
    var body: some View {
        VStack(spacing: 0.0) {
            
            // Existing broker IP view
            if !mqttSettings.brokerIP.isEmpty {
                Text(mqttSettings.isConnected ? "Connected" : "Disconnected")
                    .frame(maxWidth: .infinity)
                    .padding([.vertical], 5)
                    .background(mqttSettings.isConnected
                                ? Color("ConnectedColor")
                                : (mqttSettings.settingsChanged ? Color.orange
                                   : Color("DisconnectedColor"))
                    )
                    .fontWeight(.semibold)
                    .onChange(of: mqttSettings.settingsChanged) {
                        print("Settings have changed. ")
                        clearMessages()
                        mqttSettings.isConnected = false
                        
                    }
            } else {
                Text("Please update your settings")
                    .frame(maxWidth: .infinity)
                    .padding([.vertical], 5)
                    .background(Color("SecondColor"))
            }
            
        }
    }
    func clearMessages() -> Void {
        mqttSettings.receivedMessages = []
    }
}
