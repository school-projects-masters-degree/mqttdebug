//
//  UIWrapper.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 21.10.23.
//

import SwiftUI

struct UIWrapper: View {
    @StateObject private var mqttSettings = MQTTSettings()
    @StateObject private var iotManager: IoTManager
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedTab = 1
    
    init() {
        let mqttSettings = MQTTSettings()
        _mqttSettings = StateObject(wrappedValue: mqttSettings)
        _iotManager = StateObject(wrappedValue: IoTManager(mqttSettings: mqttSettings))
    }
    
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
            MessagesView(mqttSettings: mqttSettings)
                .tabItem {
                    Image(systemName: "house")
                }.tag(1)
            
            SettingsView(mqttSettings: mqttSettings)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }.tag(2)
            
            if mqttSettings.isFavoriteTabVisible {
                SubscribedView(mqttSettings: mqttSettings).tabItem {
                    Image(systemName: "bell.fill")
                }.tag(3)
            }
        }
        
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color("TabViewColor"))
        }
        
    }
    func isValidPort(_ port: Int) -> Bool {
        return (0...65535).contains(port)
    }
}
