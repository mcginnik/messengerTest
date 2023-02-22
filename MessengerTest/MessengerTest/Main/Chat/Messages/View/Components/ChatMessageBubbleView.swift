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
            if isReceived {
                getUserImage(for: message)
            }
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
    
    private func getUserImage(for message: ChatMessage) -> some View {
        Image(systemName: "person.fill")
            .foregroundColor(.primary)
            .frame(width: 36, height: 36)
            .clipped()
            .cornerRadius(.infinity)
            .overlay(RoundedRectangle(cornerRadius: .infinity)
                        .stroke(Color.secondary, lineWidth: 1))
    }

}

struct ChatMessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageBubbleView(message: ChatMessage.getTestMessage(), width: 250)
    }
}
