import SwiftUI

struct SubscribedView: View {
    @ObservedObject var mqttSettings: MQTTSettings  // Expect mqttSettings to be passed in

    private var groupedMessages: [String: [MQTTSettings.MQTTMessage]] {
        Dictionary(grouping: mqttSettings.receivedMessages.filter { $0.isFavorite }) { $0.topic }
    }

    var body: some View {
        if groupedMessages.isEmpty{
            Text("No Messages Saved.")
        }
        List {
            ForEach(groupedMessages.keys.sorted(), id: \.self) { topic in
                Section(header: Text(topic)) {
                    ForEach(groupedMessages[topic] ?? [], id: \.id) { message in
                        Text(message.message)
                    }
                    .onDelete(perform: { indexSet in
                        deleteMessages(at: indexSet, in: topic)
                    })
                }
            }
        }
    }

    private func deleteMessages(at indexSet: IndexSet, in topic: String) {
        guard let messages = groupedMessages[topic] else { return }

        for index in indexSet {
            if let globalIndex = mqttSettings.receivedMessages.firstIndex(where: { $0.id == messages[index].id }) {
                mqttSettings.receivedMessages.remove(at: globalIndex)
            }
        }
    }
}
