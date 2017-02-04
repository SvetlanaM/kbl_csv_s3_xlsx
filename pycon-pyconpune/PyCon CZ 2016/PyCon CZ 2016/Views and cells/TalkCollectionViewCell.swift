//
//  TalkCollectionViewCell.swift
//  PyCon CZ 2016
//
//  Created by Svetlana Margetová on 15.10.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

class TalkCollectionViewCell: UICollectionViewCell {
    
    var date : UILabel!
    var title : UILabel!
    var speakerLabel : UILabel!
    var speakerBioLabel : UILabel!
    
    
    required init(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let dateFrame = CGRectMake(0, (frame.height/10.0), 80, 100)
        date = UILabel(frame: dateFrame)
        date.font = UIFont.boldSystemFontOfSize(18.0)
        date.textColor = .blackColor()
        date.backgroundColor = .whiteColor()
        date.textAlignment = .Center
        date.numberOfLines = 3
        let border = CALayer()
        border.backgroundColor = UIColor(red: 205/255.0, green: 209/255.0, blue: 213/255.0, alpha: 1.0).CGColor
        border.frame = CGRect(x: 75, y: 0, width: 0.5, height: dateFrame.height)
        
        date.layer.addSublayer(border)
        date.lineBreakMode = .ByWordWrapping
        contentView.addSubview(date)
        
        let titleFrame = CGRectMake(90, -100, (self.frame.size.width)-110, 300)
        title = UILabel(frame: titleFrame)
        title.font = UIFont.systemFontOfSize(16.0)
        title.textColor = .blackColor()
        title.textAlignment = .Left
        title.numberOfLines = 2
        contentView.addSubview(title)
        
        let speakerFrame = CGRectMake(90, -15, (self.frame.size.width)-110, 200)
        speakerLabel = UILabel(frame: speakerFrame)
        speakerLabel.font = UIFont.systemFontOfSize(14.0)
        speakerLabel.textColor = DataManager.sharedInstance.config.pyconColor
        speakerLabel.textAlignment = .Left
        speakerLabel.numberOfLines = 1
        speakerLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(speakerLabel)
        
    }
    
    func configureCell(talks : Talk) {
        if let sDate = talks.startDate, let sStartTime = talks.startTime, let sEndTime = talks.endTime, let sEndDate = talks.endDate {
            if sDate == sEndDate {
                date.text = sDate + "\n" + sStartTime + "\n" + sEndTime
            } else {
                date.text = sDate + "\n" + sStartTime
            }
            
        }
        title.text = talks.title
        speakerLabel.text = talks.speaker
        setFontSize(title, type : talks.type ?? "")
        
    }
    
    func setFontSize(label : UILabel, type : String) {
        if type == "event" {
            label.font = UIFont.boldSystemFontOfSize(22.0)
            speakerLabel.text = "Enjoy your time"
        }
        else {
            label.font = UIFont.systemFontOfSize(16.0)
        }
    }
    
}
