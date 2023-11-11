//
//  NavigationBarView.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 21.10.23.
//

import SwiftUI

struct NavigationBarView: View {
    var body: some View {
        NavigationView {
            VStack {
               Text("MQTTDebug")
                    .bold()
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    
                    .background(Color.blue)
            }
            
            
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationBarView()
}
