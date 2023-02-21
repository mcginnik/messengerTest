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

    init(channel: Channel) {
        self.channel = channel
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                viewModel.channel = channel
            }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(channel: .getTestChannel())
    }
}
