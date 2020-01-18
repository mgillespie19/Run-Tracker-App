//
//  DashboardRootView.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/16/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import SwiftUI

struct DashboardRootView: View {
    var viewModel: DashboardViewModel
    
    var body: some View {
        Text("Dashboard")
    }
}

struct DashboardRootView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardRootView(viewModel: DashboardViewModel())
    }
}
