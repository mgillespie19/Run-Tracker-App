//
//  ExploreRootView.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/16/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import SwiftUI

struct ExploreRootView: View {
    var viewModel: ExploreViewModel
    
    var body: some View {
        Text("explore")
    }
}

struct ExploreRootView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreRootView(viewModel: ExploreViewModel())
    }
}
