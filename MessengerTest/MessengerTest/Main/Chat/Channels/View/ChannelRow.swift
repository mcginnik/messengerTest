//
//  ChannelRow.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

struct ChannelRow: View {
    
    let channel: Channel
    
    var body: some View {
        NavigationLink {
            Text("\(channel.name)")
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
        ChannelRow(channel: .init(id: "", url: "", type: .open, createdAt: 0, name: "Test"))
    }
}
