//
//  RootTabView.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/16/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import SwiftUI

struct RootTabView: View {
    @State var selectedView = 1

    var body: some View {
        ZStack {
            TabView(selection: $selectedView) {
                FeedRootView(viewModel: FeedViewModel()).tabItem {
                    Text("Feed")
                    Image(systemName: "house")
                }.tag(1)
                ExploreRootView(viewModel: ExploreViewModel()).tabItem {
                    Text("Groups")
                    Image(systemName: "person.3")
                }.tag(2)
                NewWorkoutRootView(viewModel: NewWorkoutViewModel()).tabItem {
                    Text("Explore")
                    Image("explore")
                }.tag(3)
                DashboardRootView(viewModel: DashboardViewModel()).tabItem {
                    Text("Discover")
                    Image(systemName: "map")
                }.tag(4)
                EventsRootView(viewModel: EventsViewModel()).tabItem {
                    Text("Events")
                    Image(systemName: "calendar")
                }.tag(5)
            }
            .accentColor(Color("PurpleNurple"))
            NewWorkoutButton()
        }.edgesIgnoringSafeArea(.top)
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
