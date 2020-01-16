//
//  NewWorkoutRootView.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/16/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import SwiftUI

struct NewWorkoutRootView: View {
    var viewModel: NewWorkoutViewModel
    
    var body: some View {
        Text("New workout")
    }
}

struct NewWorkoutRootView_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkoutRootView(viewModel: NewWorkoutViewModel())
    }
}
