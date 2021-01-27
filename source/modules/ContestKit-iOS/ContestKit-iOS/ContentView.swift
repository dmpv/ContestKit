//
//  ContentView.swift
//  ContestKit-iOS
//
//  Created by Dmitry Purtov on 25.01.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingEditor = true

    var body: some View {
        Button("Edit") {
           self.showingEditor = true
        }
        .sheet(isPresented: $showingEditor) {
            Editor()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
