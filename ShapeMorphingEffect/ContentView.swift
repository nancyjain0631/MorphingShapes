//
//  ContentView.swift
//  ShapeMorphingEffect
//
//  Created by Nancy Jain on 05/08/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            // MARK: Project 2
//        MorphingView()
//            .preferredColorScheme(.dark)
            // MARK: Project 1
        IntroView()
            .environment(\.colorScheme, .dark)
    }
}

#Preview {
    ContentView()
}
