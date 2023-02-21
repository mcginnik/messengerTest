//
//  MessagesGridView.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/21/23.
//

import SwiftUI

struct MessagesGridView: View {
    
    let columns: [GridItem]
    let messages: [ChatMessage]
    let width: CGFloat
    static let lastMessageAnchorId = "lastMessageAnchor"
    
    init(columns: [GridItem] = [GridItem(.flexible(minimum: 10))],
         messages: [ChatMessage],
         width: CGFloat){
        self.columns = columns
        self.messages = messages
        self.width = width
    }

    var body: some View {
        LazyVGrid(columns : columns, spacing: 0) {
            ForEach(messages) { message in
                ChatMessageBubbleView(message: message, width: width * 0.85)
            }
            Spacer()
                .frame(height: 80)
                .id(MessagesGridView.lastMessageAnchorId)
        }
    }
}
