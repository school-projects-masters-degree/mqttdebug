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
                    /*.onTapGesture {
                        print("Tap gesture recognized")
                        if mqttSettings.settingsChanged {
                            print("Settings have changed. Attempting to reconnect...")
                            
                            iotManager.disconnect()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                iotManager.connectToServer()
                            }
                            mqttSettings.settingsChanged = false
                        }
                    }*/
                /*
                if mqttSettings.settingsChanged {
                    Text("Settings Changed - Tap Here To Reconnect")
                        .frame(maxWidth: .infinity)
                        .padding([.vertical], 5)
                        .foregroundColor(.white)
                        .background(Color.orange)
                        .fontWeight(.semibold)
                }
                 */
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
