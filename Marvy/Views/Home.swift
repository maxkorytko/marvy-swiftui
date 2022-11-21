//
//  Home.swift
//  Marvy
//
//  Created by Maksym Korytko  on 7/4/22.
//

import MarvelApi
import SwiftUI

struct Home: View {
    let api = MarvelApi()

    var body: some View {
        Text("Marvy")
            .task {
                fetchCharacters()
            }
    }

    private func fetchCharacters() {

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}