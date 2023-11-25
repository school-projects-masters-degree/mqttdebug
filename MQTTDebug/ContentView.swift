//
//  ContentView.swift
//  MQTTDebug
//
//  Created by ALsJourney on 14.10.23.
//

import SwiftUI
struct ContentView: View {
    
    @StateObject private var mqttSettings = MQTTSettings()
    @StateObject private var iotManager =  IoTManager(mqttSettings: MQTTSettings())
    
    var body: some View {
        UIWrapper()
    }
}

#Preview {
    ContentView()
}
