//
//  FeedPostRunDetails.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/18/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import SwiftUI

struct FeedPostRunDetails: View {
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(color: Color("LightGrey"), radius: 3)
                
                VStack {
                    Text("Distance")
                        .font(.caption)
                        .padding(.top)
                    
                    Text("9.49 miles")
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.bottom)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.30)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(color: Color("LightGrey"), radius: 3)
                
                VStack {
                    Text("Duration")
                        .font(.caption)
                        .padding(.top)
                    
                    Text("1:10:33")
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.bottom)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.30)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .shadow(color: Color("LightGrey"), radius: 3)
                
                VStack {
                    Text("Average Pace")
                        .font(.caption)
                        .padding(.top)
                    
                    Text("7:26")
                        .fontWeight(.semibold)
                        .padding(.top)
                        
                    Text("min/mi")
                        .fontWeight(.semibold)
                        .padding(.bottom)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.30)
        }
//        .frame(height: 80)
    }
}

struct FeedPostRunDetails_Previews: PreviewProvider {
    static var previews: some View {
        FeedPostRunDetails()
    }
}
