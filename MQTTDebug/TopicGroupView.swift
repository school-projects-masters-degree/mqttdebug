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
    var mqttSettings: MQTTSettings
    
    @State private var isExpanded: Bool = false
    @State private var currentDate = Date()
    
    private var borderColor: Color {
        guard let mostRecentMessage = messages.max(by: { $0.timestamp < $1.timestamp }) else {
            return Color.gray
        }
        
        let timeInterval = currentDate.timeIntervalSince(mostRecentMessage.timestamp)
        let grayScaleValue: Double = determineGrayScaleValue(for: timeInterval)
        return Color(white: grayScaleValue)
        
    }
    
    private func determineGrayScaleValue(for timeInterval: TimeInterval) -> Double {
        switch timeInterval {
        case 0..<10:  // Less than 10 sec
            // Dark Gray
            return 0.2
        case 10..<30:  // Older than 10 sec
            // Medium Gray
            return 0.5
        default:  // Older than 30 sec
            // Lighter Gray
            return 0.8
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Star (Favorite) Button
                Button(action: {
                    mqttSettings.toggleFavoriteStatusForTopic(topic)
                }) {
                    Image(systemName: isTopicFavorite(topic) ? "star.fill" : "star")
                        .foregroundColor(isTopicFavorite(topic) ? .yellow : .gray)
                }

                
                // Fixing double toggle bug
                .buttonStyle(PlainButtonStyle())
                Spacer()
            
                // Topic Button to Expand/Collapse
                Button(action: { isExpanded.toggle() }) {
                    HStack {
                        Text(topic)
                            .fontWeight(.bold)
                            .foregroundColor(borderColor)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    }
                }
                .buttonStyle(PlainButtonStyle())
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
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            currentDate = Date()  // Refresh the current date every second
        }
    }
    
    
    private func isTopicFavorite(_ topic: String) -> Bool {
        return mqttSettings.receivedMessages.contains(where: {
            $0.topic == topic && $0.isFavorite
        })
    }
}
