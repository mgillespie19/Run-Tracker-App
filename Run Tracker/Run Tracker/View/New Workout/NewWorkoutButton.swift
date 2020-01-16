//
//  NewWorkoutButton.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/16/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import SwiftUI

struct NewWorkoutButton: View {
    @State var displayingExplore = false

    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                self.displayingExplore.toggle()
            }) {
                Image(systemName: "plus")
                    .padding()
                    .frame(width: 100, height: 55)
                    .foregroundColor(Color.white)
            }
            .background(Color("Pink"))
            .cornerRadius(10)
            .shadow(radius: 4)
        }.sheet(isPresented: $displayingExplore, content: {
            NewWorkoutRootView(viewModel: NewWorkoutViewModel())
        })
    }
}

struct NewWorkoutButton_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkoutButton()
    }
}
