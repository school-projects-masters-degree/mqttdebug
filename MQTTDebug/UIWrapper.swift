//
//  UIWrapper.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 21.10.23.
//

import SwiftUI

struct UIWrapper: View {
    @StateObject private var mqttSettings = MQTTSettings()
    @StateObject private var iotManager =  IoTManager(mqttSettings: MQTTSettings())
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedTab = 1
    var body: some View {
        VStack(spacing: 0.0) {
            Text("MQTTDebugger")
                .frame(maxWidth: .infinity)
                .font(.title)
                .fontWeight(.bold)
                .padding([.bottom], 15)
                .background(Color("MainColor"))
            ConnectionStatusView(mqttSettings: mqttSettings, iotManager: iotManager)
        }
        TabView(selection: $selectedTab) {
            MessagesView(mqttSettings: mqttSettings).tabItem { Label( "home", systemImage: "house")
                .foregroundColor(Color("DarkIcons")).fontWeight(.bold) }.tag(1)
        
            SettingsView(mqttSettings: mqttSettings)
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }.tag(2)
            SubscribedView(mqttSettings: mqttSettings).tabItem { Label("Favorites", systemImage: "bell.fill")
                    
            }.tag(3)
                

        }
        
        .onAppear {
            if isValidPort(mqttSettings.portNumber) {
                iotManager.configure(clientID: "MQTTDebug-", serverURL: mqttSettings.brokerIP, serverPort: UInt16(mqttSettings.portNumber), username: mqttSettings.username, password: mqttSettings.password)
                UITabBar.appearance().backgroundColor = UIColor(Color("MainColor"))
            } else {
                alertMessage = "Invalid Port number. Please use a number between 0 and 65535"
                showAlert = true
            }
                
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
        }
    }
    func isValidPort(_ port: Int) -> Bool {
            return (0...65535).contains(port)
    }
}

#Preview {
    UIWrapper()
}
