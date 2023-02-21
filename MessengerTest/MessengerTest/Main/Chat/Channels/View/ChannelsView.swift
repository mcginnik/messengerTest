//
//  ChannelsView.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

struct ChannelsView: View {

    // MARK: Properties
    
    @StateObject var viewModel: ChannelsViewModel = ChannelsViewModel()
    @State var showChannelNameInput: Bool = false
    @State var channelName: String = ""
    
    // MARK: Views

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
            ToolbarItem(placement: .navigationBarLeading) {
                Picker("", selection: $viewModel.channelType) {
                    ForEach(ChannelType.allCases, id: \.self) { filter in
                        Text(filter.descriptionCTA)
                            .padding()
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.channels, id: \.self) { item in
                    ChannelRow(channel: item)
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
                    await viewModel.fetchChannels()
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
    
    // MARK: Actions
    
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

struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelsView()
    }
}
