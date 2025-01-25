//
//  LoadingView.swift
//  helloworld
//
//  Created by Simon Sung on 1/25/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        // Display a progress indicator with a circular style, tinted white
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            // Ensure the ProgressView takes up the maximum available space
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
