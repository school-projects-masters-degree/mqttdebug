//
//  SettingsView.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 21.10.23.
//

import SwiftUI

struct SettingsView: View {
    @State private var savePassword: Bool = UserDefaults.standard.bool(forKey: "savePassword")
    @ObservedObject var mqttSettings: MQTTSettings
    
    var body: some View {
        Form {
            Section(header: Text("MQTT Settings")) {
                TextField("Broker IP", text: $mqttSettings.brokerIP)
                    .onChange(of: mqttSettings.brokerIP) {
                        mqttSettings.settingsChanged = true
                        UserDefaults.standard.set(mqttSettings.brokerIP, forKey: "brokerIP")
                    }
                TextField("Port Number", value: $mqttSettings.portNumber, formatter: NumberFormatter())
                    .onChange(of: mqttSettings.portNumber) {
                        mqttSettings.settingsChanged = true
                        UserDefaults.standard.set(mqttSettings.portNumber, forKey: "portNumber")
                    }
                TextField("Username", text: $mqttSettings.username)
                    .onChange(of: mqttSettings.username) {
                        mqttSettings.settingsChanged = true
                        UserDefaults.standard.set(mqttSettings.username, forKey: "username")
                    }
                // Use Secure Field for Password
                SecureField("Password", text: $mqttSettings.password)
                    .onChange(of: mqttSettings.password) {
                        mqttSettings.settingsChanged = true
                        savePasswordIfNeeded()
                    }
                TextField("Topic", text: $mqttSettings.topic)
                    .onChange(of: mqttSettings.topic) {
                        mqttSettings.settingsChanged = true
                        UserDefaults.standard.set(mqttSettings.topic, forKey: "topic")
                    }
                Toggle(isOn: $savePassword) {
                    Text("Save my password for next time.")
                    // .checkBox isnt available in iOS
                    .onChange(of: savePassword) {
                        UserDefaults.standard.set(savePassword, forKey: "savePassword")
                        savePasswordIfNeeded()
                    }
                }.toggleStyle(iOSCheckBoxToggleStyle())
            }
            
        }
        .background(Color.white)
        
        // Clear Passwords if Box is Unchecked
        .onAppear() {
            if savePassword {
                mqttSettings.password = UserDefaults.standard.string(forKey: "password") ?? ""
            }
        }
        
    }
    
    func savePasswordIfNeeded() {
        if savePassword {
            UserDefaults.standard.set(mqttSettings.password, forKey: "password")
        } else {
            UserDefaults.standard.removeObject(forKey: "password")
            
        }
    }
}


