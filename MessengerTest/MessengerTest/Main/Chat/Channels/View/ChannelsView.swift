//
//  ChannelsView.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

struct ChannelsView: View {
    var body: some View {
        VStack {
            ForEach(0..<10, id: \.self) { _ in
                Text("Channel")
            }
        }
    }
}

struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelsView()
    }
}
