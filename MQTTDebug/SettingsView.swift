//
//  SettingsView.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 21.10.23.
//

import SwiftUI

struct SettingsView: View {
    @State private var isInputValid: Bool = true
    
    @ObservedObject var mqttSettings: MQTTSettings
    
    var body: some View {
        Form {
            Section(header: Text("MQTT Settings")) {
                TextField("Broker IP", text: $mqttSettings.brokerIP)
                    .onChange(of: mqttSettings.brokerIP) {
                        mqttSettings.settingsChanged = true
                    }
                TextField("Port Number", value: $mqttSettings.portNumber, formatter: NumberFormatter())
                    .onChange(of: mqttSettings.portNumber) {
                        mqttSettings.settingsChanged = true
                    }
                TextField("Username", text: $mqttSettings.username)
                    .onChange(of: mqttSettings.username) {
                        mqttSettings.settingsChanged = true
                    }
                SecureField("Password", text: $mqttSettings.password)
                    .onChange(of: mqttSettings.password) {
                        mqttSettings.settingsChanged = true
                    }
                TextField("Topic", text: $mqttSettings.topic)
                    .onChange(of: mqttSettings.topic) {
                        mqttSettings.settingsChanged = true
                    }
            }
        }
        .background(Color.white)

        }
}

/*
#Preview {
    
      
   

    SettingsView(
        content($brokerIP, $portNumber, $username, $password, $topic)
    )
}
 */
 

