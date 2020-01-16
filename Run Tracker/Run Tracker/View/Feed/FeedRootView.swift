//
//  FeedRootView.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/16/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import SwiftUI

struct FeedRootView: View {
    var viewModel: FeedViewModel
    
    var body: some View {
        Text("Feed")
    }
}

struct FeedRootView_Previews: PreviewProvider {
    static var previews: some View {
        FeedRootView(viewModel: FeedViewModel())
    }
}
