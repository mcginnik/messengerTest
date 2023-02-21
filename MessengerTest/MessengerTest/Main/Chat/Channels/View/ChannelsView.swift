//
//  ChannelsView.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

struct ChannelsView: View {

    @StateObject var viewModel: ChannelsViewModel = ChannelsViewModel()
    @State var showChannelNameInput: Bool = false
    @State var channelName: String = ""
    
    var toolbarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: showAddChannel) {
                    Label(StringConstants.addItem, systemImage: "plus")
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.channels, id: \.self) { item in
                    NavigationLink {
                        Text("\(item.id)")
    //                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text("\(item.name)")
                        //Text(item.timestamp!, formatter: itemFormatter)
                    }
                    .onAppear {
                        if item == viewModel.channels.last {
                            Task {
                                await viewModel.loadNextPage()
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .refreshable {
                Task {
                    await viewModel.fetchOpenChannels()
                }
            }
            .toolbar {
                toolbarItems
            }
        }

        .alert(StringConstants.newChannel, isPresented: $showChannelNameInput, actions: {
            TextField(StringConstants.channelName, text: $channelName)
            Button(StringConstants.createChannelCTA, action: addItem)
            Button(StringConstants.cancelCTA, role: .cancel, action: {})
        }, message: {
            Text(StringConstants.createChannelDescription)
        })
    }
    
    private func showAddChannel(){
        showChannelNameInput.toggle()
    }

    private func addItem() {
        Task {
            await viewModel.createChannel(withName: channelName)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        Task {
            await viewModel.deleteChannels(at: offsets)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelsView()
    }
}
