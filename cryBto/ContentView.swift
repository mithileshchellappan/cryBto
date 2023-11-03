//
//  ContentView.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 26/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.theme.background.ignoresSafeArea()
            VStack{
                Text("Accent")
                    .foregroundColor(Color.theme.accent)
                
                Text("Secondary")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
