//
//  MQTTSettings.swift
//  MQTTDebug
//
//  Created by Aldin Cimpo on 16.11.23.
//

import Foundation

class MQTTSettings: ObservableObject {
    
    @Published var receivedMessages: [MQTTMessage] = []
    
    @Published var brokerIP: String = "10.55.200.204"
    @Published var portNumber: Int = 1883 // Default port
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var topic: String = "#"
    @Published var isConnected: Bool = false
    @Published var connectionError: String?
    @Published var settingsChanged = false
    @Published var favoriteTopics: Set<String> = []
    @Published var favoriteMessages: [MQTTSettings.MQTTMessage] = []
    
    var isFavoriteTabVisible: Bool {
        return !favoriteMessages.isEmpty
    }
    
    
    // Fixing the Favorite Tab with this closure
    var onFavoritesChanged: (() -> Void)?
    
    private let favoritesKey = "FavoriteTopics"
    private let MAX_MESSAGE_COUNT = 20
    init() {
        loadSettings()
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
        print("Saving favorite messages: \(favoriteMessages.count)")
        
        onFavoritesChanged?()
    }
    
    func loadFavoriteMessages() {
        if let data = UserDefaults.standard.data(forKey: favoritedMessagesKey),
           let savedMessages = try? JSONDecoder().decode([MQTTMessage].self, from: data) {
            print("Found data for favorite messages")
            
            // Merge with existing messages or replace, as per your logic
            favoriteMessages = savedMessages
            receivedMessages = savedMessages
            
        } else {
            print("No data found")
        }
        
    }
    
    func toggleFavoriteStatusForTopic(_ topic: String) {
        for i in 0..<receivedMessages.count {
            if receivedMessages[i].topic == topic {
                receivedMessages[i].isFavorite.toggle()
            }
        }
        
        saveFavoriteMessages()
        print("Toggled favorite status for topic: \(topic)")
        saveFavoriteMessages()
        
    }
    
    // Fix the Favorites Tab Duplicate Bug
    func synchronizeFavoriteMessages() {
        // Load from UserDefaults first
        loadFavoriteMessages()
        // Now update receivedMessages with favorite status
        for (index, message) in receivedMessages.enumerated() {
            if favoriteMessages.contains(where: { $0.id == message.id }) {
                receivedMessages[index].isFavorite = true
            }
        }
    }
    
    // Allow max 20 Messages
    func addMessage(_ message: MQTTMessage) {
        receivedMessages.append(message)
        
        if receivedMessages.count > MAX_MESSAGE_COUNT {
            receivedMessages.removeFirst()
        }
    }
    
    
    func loadSettings() {
        brokerIP = UserDefaults.standard.string(forKey: "brokerIP") ?? "10.55.200.204"
        portNumber = UserDefaults.standard.integer(forKey: "portNumber")
        if portNumber == 0 { portNumber = 1883 } // Default port if not set
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        password = UserDefaults.standard.string(forKey: "password") ?? ""
        topic = UserDefaults.standard.string(forKey: "topic") ?? "#"
    }
    
}
