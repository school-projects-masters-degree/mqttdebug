//
//  TopicGroupView.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 07.12.23.
//

import SwiftUI

struct TopicGroupView: View {
    let topic: String
       let messages: [MQTTSettings.MQTTMessage]
       @State private var isExpanded: Bool = false

       var body: some View {
           VStack(alignment: .leading) {
               Button(action: { isExpanded.toggle() }) {
                   HStack {
                       Text(topic)
                           .fontWeight(.bold)
                       Spacer()
                       Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                   }
               }

               if isExpanded {
                   ForEach(messages, id: \.id) { message in
                       VStack(alignment: .leading) {
                           Text("\(message.message)")
                           Text("Received at: \(message.timestamp.formatted())")
                               .font(.caption)
                               .foregroundColor(.gray)
                       }
                   }
               }
           }
           .padding()
       }
}

