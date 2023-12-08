//
//  MQTTSettings.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 16.11.23.
//

import Foundation

class MQTTSettings: ObservableObject {
    
    @Published var receivedMessages: [MQTTMessage] = []
    
    @Published var brokerIP: String = "192.168.8.159"
    @Published var portNumber: Int = 1883 // Default port
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var topic: String = "#"
    @Published var isConnected: Bool = false
    @Published var connectionError: String?
    @Published var settingsChanged = false
    @Published var favoriteTopics: Set<String> = []
    
    private let favoritesKey = "FavoriteTopics"
    private var favoriteMessages: [MQTTSettings.MQTTMessage] = []
    init() {
        loadFavoriteMessages()
    }
    
    struct MQTTMessage: Identifiable, Codable {
        // Identify by UUID
        var id = UUID()
        let topic: String
        let message: String
        let timestamp: Date
        // Check for new Messages
        // var to make it mutable
        var isNew: Bool
        var isFavorite: Bool = false
    }
    
    func markAllMessagesAsRead() {
        for i in 0..<receivedMessages.count {
            receivedMessages[i].isNew = false
        }
    }
    
    
    // Key for storing favorite messages
    private let favoritedMessagesKey = "FavoritedMessages"
    
    
    func saveFavoriteMessages() {
        favoriteMessages = receivedMessages.filter { $0.isFavorite }
        if let encoded = try? JSONEncoder().encode(favoriteMessages) {
            UserDefaults.standard.set(encoded, forKey: favoritedMessagesKey)
        }
    }
    
    func loadFavoriteMessages() {
        if let data = UserDefaults.standard.data(forKey: favoritedMessagesKey),
           let savedMessages = try? JSONDecoder().decode([MQTTMessage].self, from: data) {
            // Merge with existing messages or replace, as per your logic
            receivedMessages = savedMessages
        }
    }
    
    func toggleFavoriteStatusForTopic(_ topic: String) {
        for i in 0..<receivedMessages.count {
            if receivedMessages[i].topic == topic {
                receivedMessages[i].isFavorite.toggle()
            }
        }
        
        saveFavoriteMessages()
    }
    
}
