//
//  FeedFilterView.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/17/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import SwiftUI

struct FeedFilterView: View {
    @Binding var friendsTabSelected: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color("VeryLightGrey"))
                .frame(width: UIScreen.main.bounds.width * 0.44, height: 40)
                .cornerRadius(7)
                .offset(x: friendsTabSelected ? 0 : UIScreen.main.bounds.width / 2)
                .padding(.leading)
                .padding(.trailing)
                .animation(.default)

            HStack {
                Button(action: {
                    self.friendsTabSelected = true
                    print("friends tab selected: \(self.friendsTabSelected)")
                }, label: {
                    Text("Friends")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width / 2)
                })

                Button(action: {
                    self.friendsTabSelected = false
                    print("friends tab selected: \(self.friendsTabSelected)")
                }, label: {
                    Text("Me")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width / 2)
                })
            }
        }
    }
}

struct FeedFilterView_Previews: PreviewProvider {
    @State static var selected = false
    
    static var previews: some View {
        FeedFilterView(friendsTabSelected: $selected)
    }
}
