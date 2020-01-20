//
//  FeedItem.swift
//  Run Tracker
//
//  Created by Max Gillespie on 1/20/20.
//  Copyright © 2020 Max Gillespie. All rights reserved.
//

import Foundation

class FeedItem: Identifiable, Comparable {
    var title: String
    var note: String
    var date: String
    var author: String
    var sleep_hr: Double
    var last_updated_timestamp: String
    var activity_list: [Activity]
    var like_list: [String]
    var comment_list: [Comment]
    
    init(Title: String, Note: String, Date: String, Author: String, SleepHr: Double, LastUpdatedTimestamp: String, ActivityList: [Activity], LikeList: [String], CommentList: [Comment]) {
        self.title = Title
        self.note = Note
        self.date = Date
        self.author = Author
        self.sleep_hr = SleepHr
        self.last_updated_timestamp = LastUpdatedTimestamp
        self.activity_list = ActivityList
        self.like_list = LikeList
        self.comment_list = CommentList
    }
    
    // MARK:- Comparable Protocol Stubs
    static func < (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.date == rhs.date
    }
}
