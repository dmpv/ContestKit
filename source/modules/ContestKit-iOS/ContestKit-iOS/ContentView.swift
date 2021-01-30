//
//  ContentView.swift
//  ContestKit-iOS
//
//  Created by Dmitry Purtov on 25.01.2021.
//

import SwiftUI

import ContestKit

struct ContentView: View {
    var body: some View {
        Button("Edit") {
            AppComponents.shared.store.dispatch(
                AppComponents.shared.module.startEditing()
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
