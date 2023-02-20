//
//  MainView.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        if viewModel.isAuthenticated {
            ChannelsView()
        } else {
            LoadingView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
