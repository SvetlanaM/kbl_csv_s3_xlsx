//
//  Talk.swift
//  PyCon CZ 2016
//
//  Created by Svetlana Margetová on 12.11.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Talk : NSObject {
    
    let key : String
    var title : String
    var avatar : UIImage?
    var bio : String?
    var talkDescription: String?
    var endTime : String?
    var endDate : String?
    var github : String?
    var speaker : String?
    var startTime : String?
    var startDate : String?
    var twitter : String?
    var votes = [Int]()
    var type : String?
    var active : Bool?
    var rawDate : String?
    let ref : FIRDatabaseReference?
    
    init(key : String, title : String, avatar : UIImage, bio : String, talkDescription : String, endTime : String, endDate : String, github : String, speaker : String, startTime : String, startDate : String, twitter : String, type : String) {
        self.key = key
        self.title = title
        self.avatar = avatar
        self.bio = bio
        self.talkDescription = talkDescription
        self.endDate = endDate
        self.endTime = endTime
        self.github = github
        self.startDate = startDate
        self.startTime = startTime
        self.twitter = twitter
        self.ref = nil
        self.speaker = speaker
        self.type = type
    }
    
    init(snapshot : FIRDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        
        if let talktTitle = snapshot.value!["title"] as? String {
            // For event types such as breaks, lunch, lighting talks, etc...
            if talktTitle == "" {
                title = snapshot.value!["description"] as? String ?? ""
            } else {
                title = talktTitle
            }
        } else {
            title = ""
        }
    
        
        if let speakerAvatar = snapshot.value!["avatar"] as? String {
            var urlString = speakerAvatar
            let url = urlString
            let urlImage = NSURL(string: url)
            let data = NSData(contentsOfURL: urlImage!)
            if let dataContent = data {
                avatar = UIImage(data: dataContent)
            } else {
                
                avatar = UIImage(named: "speaker_avatar")

            }
            
        }
        
        if let speakerBio = snapshot.value!["bio"] as? String {
            bio = speakerBio
        } else {
            bio = ""
        }
        
        if let description = snapshot.value!["description"] as? String {
            talkDescription = description
        } else {
            talkDescription = ""
        }
        
        if let speakerTwitter = snapshot.value!["twitter"] as? String {
            twitter = speakerTwitter
        } else {
            twitter = ""
        }
        
        if let speakerName = snapshot.value!["speaker"] as? String {
            speaker = speakerName
        } else {
            speaker = ""
        }
        
        if let talkStartTime = snapshot.value!["start_time"] as? String {
            startTime = talkStartTime
        } else {
            startTime = ""
        }
        
        if let talkEndTime = snapshot.value!["end_time"] as? String {
            endTime = talkEndTime
        } else {
            endTime = ""
        }
        
        if let talkEndDate1 = snapshot.value!["end_date"] as? String {
            rawDate = talkEndDate1
        } else {
            rawDate = ""
        }
        
        if let talkEndDate = snapshot.value!["end_date"] as? String {
            endDate = talkEndDate
        } else {
            endDate = ""
        }
        
        if let talkStartDate = snapshot.value!["start_date"] as? String {
            startDate = talkStartDate
        } else {
            startDate = ""
        }
        
        if let talkType = snapshot.value!["type"] as? String {
            type = talkType
        } else {
            type = ""
        }
        
        if let isActive = snapshot.value!["active"] as? Bool {
            active = isActive
        } else {
            active = true
        }
    }
}


