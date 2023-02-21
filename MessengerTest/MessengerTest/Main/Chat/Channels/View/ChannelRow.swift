//
//  ChannelRow.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

struct ChannelRow: View {
    
    // MARK: Properties

    let channel: Channel
    
    // MARK: Views

    var body: some View {
        NavigationLink {
            MessagesView(channel: channel)
        } label: {
            HStack {
                Text("\(channel.name)")
                Spacer()
                Text(Date(timeIntervalSince1970: Double(channel.createdAt)).descriptiveString())
                    .font(.footnote)
            }
        }
    }
}

struct ChannelRow_Previews: PreviewProvider {
    static var previews: some View {
        ChannelRow(channel: Channel.getTestChannel())
    }
}
