//
//  EventsRootView.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/16/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import SwiftUI

struct EventsRootView: View {
    var viewModel: EventsViewModel
    
    var body: some View {
        Text("Events")
    }
}

struct EventsRootView_Previews: PreviewProvider {
    static var previews: some View {
        EventsRootView(viewModel: EventsViewModel())
    }
}
