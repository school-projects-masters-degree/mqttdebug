//
//  ConnectionStatusView.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 21.10.23.
//

import SwiftUI

struct ConnectionStatusView: View {
    var body: some View {
        VStack(spacing: 0.0) {
            Text("Broker 192.168.1.1")
                .frame(maxWidth: .infinity)
                .padding([.vertical], 5)
                .background(Color("SecondColor"))
            Text("Connected")
                .frame(maxWidth: .infinity)
                .padding([.vertical], 5)
                .background(Color("ConnectedColor"))
                .fontWeight(.semibold)
            
        }
    }
}

#Preview {
    ConnectionStatusView()
}
