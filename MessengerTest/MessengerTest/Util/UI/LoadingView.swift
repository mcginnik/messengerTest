//
//  LoadingView.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .tint(.white)
                .padding(.bottom, 4)
            Text(StringConstants.loading)
                .foregroundColor(.white)
                .font(.subheadline)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
