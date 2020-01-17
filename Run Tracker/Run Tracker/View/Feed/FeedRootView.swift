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
    
    @State var friendsTabSelected = true
        
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                FeedFilterView(friendsTabSelected: $friendsTabSelected)
                
                ForEach((1...10), id: \.self) {
                    Text("Post \($0)")
                }
                
            }.navigationBarTitle("Feed")
            
        }
    }
}

struct FeedRootView_Previews: PreviewProvider {
    static var previews: some View {
        FeedRootView(viewModel: FeedViewModel())
    }
}
