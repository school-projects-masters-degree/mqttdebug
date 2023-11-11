//
//  UIWrapper.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 21.10.23.
//

import SwiftUI

struct UIWrapper: View {
    let iotmanager = IoTManager(
        clientID: "MQTTDebug-",
        serverURL: "10.55.202.36"
    )
    
    var body: some View {
        VStack(spacing: 0.0) {
            Text("MQTTDebugger")
                .frame(maxWidth: .infinity)
                .font(.title)
                .fontWeight(.bold)
                .padding([.bottom], 15)
                .background(Color("MainColor"))
            ConnectionStatusView()
        }
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            MessagesView().tabItem { Label( "home", systemImage: "house")
                .foregroundColor(Color("DarkIcons")).fontWeight(.bold) }.tag(1)
        
            SettingsView().tabItem { Label("Settings", systemImage: "gearshape.fill") }.tag(2)
            SubscribedView().tabItem { Label("Favorites", systemImage: "bell.fill")
                    
            }.tag(2)
                

        }
        
        .onAppear() {
            UITabBar
                .appearance()
                .backgroundColor = UIColor(Color("MainColor"))
        }
    }
}

#Preview {
    UIWrapper()
}
