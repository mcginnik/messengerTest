//
//  MessagesView.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

struct MessagesView: View {
    
    let channel: Channel
    @StateObject var viewModel: MessagesViewModel = MessagesViewModel()
    @State var prevProxy: ScrollViewProxy?
    @FocusState var focusedField: Bool

    init(channel: Channel) {
        self.channel = channel
    }
    
    // MARK: - Views

    var keyboardInputAccessoryView: some View {
        KeyboardInputAccessoryView(text: $viewModel.chatInputText, focusedField: _focusedField) { image in
            sendButtonWasTapped(image: image)
        }
        .keyboardObserving { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let message = self.viewModel.messageToScrollTo,
                    let prevProxy = prevProxy,
                    self.focusedField == true {
                    self.scrollTo(id: message.id,
                                  shouldAnimate: self.viewModel.shouldAnimateAutoscroll,
                                  proxy: prevProxy)
                }
            }
        }
    }
    
    var messageGridView: some View {
        GeometryReader { proxy in
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    MessagesGridView(messages: viewModel.messages, width: proxy.size.width)
                        .padding(.horizontal)
                        .onChange(of: viewModel.messageToScrollTo) { newValue in
                            self.prevProxy = scrollViewProxy
                            if let message = newValue {
                                let shouldAnimate = viewModel.shouldAnimateAutoscroll
                                scrollTo(id: message.id, shouldAnimate: shouldAnimate, proxy: scrollViewProxy)
                            }
                        }
                }
            }
            .onTapGesture {
                self.focusedField = false
            }
        }
    }
    
    var body: some View {
        ZStack {
            messageGridView
            VStack(spacing: 0) {
                Spacer()
                keyboardInputAccessoryView
            }
        }
        .task {
            viewModel.channel = channel
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.customChatBackground)
    }
    
    func scrollTo(id: String, anchor: UnitPoint? = nil, shouldAnimate: Bool, proxy: ScrollViewProxy) {
        let id = MessagesGridView.lastMessageAnchorId
        DispatchQueue.main.async {
            withAnimation(shouldAnimate ? .easeIn : nil) {
                var anchor = UnitPoint.bottom
                anchor.y = anchor.y * 0.99
                proxy.scrollTo(id, anchor: anchor)
            }
        }
    }
    
    private func sendButtonWasTapped(image: UIImage?){
        self.viewModel.handleSend(image: image)
    }

}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(channel: .getTestChannel())
    }
}
