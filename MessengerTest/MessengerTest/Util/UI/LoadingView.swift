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
            Text(StringConstants.loading)
                .foregroundColor(.white)
                .font(.system(size:16, weight: .semibold))
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(8)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
