//
//  ChatMessageBubbleView.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/21/23.
//

import SwiftUI

struct ChatMessageBubbleView: View {
    
    let message: ChatMessage
    let width: CGFloat
    
    var isReceived: Bool {
        message.createdBy.id != AuthService.shared.currentUser?.id
    }
    
    var messageAndImage: some View {
        HStack(alignment: .top) {
            Text(message.text ?? "")
                .padding()
                .foregroundColor(isReceived ? .customChatBubbleLeftText : .customChatBubbleRightText)
                .background(getBackgroundColor(for: message))
                .cornerRadius(18)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            messageAndImage
        }

        .frame(width: isReceived ? width: width - 36 - 8, alignment: isReceived ? .leading : .trailing)
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
        .id(message.id)// for automatic scrolling
    }
    
    private func getBackgroundColor(for message: ChatMessage) -> Color {
        return isReceived ? .customChatBubbleLeftBackground : .customChatBubbleRightBackground
    }

}

struct ChatMessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageBubbleView(message: ChatMessage.getTestMessage(), width: 250)
    }
}
