//
//  Config.swift
//  PyCon CZ 2016
//
//  Created by Svetlana Margetová on 12.11.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        // Trim leading '#' if needed
        var cleanedHexString = hexString
        if hexString.hasPrefix("#") {
            //            cleanedHexString = dropFirst(hexString) // Swift 1.2
            cleanedHexString = String(hexString.characters.dropFirst()) // Swift 2
        }
        
        // String -> UInt32
        var rgbValue: UInt32 = 0
        NSScanner(string: cleanedHexString).scanHexInt(&rgbValue)
        
        // UInt32 -> R,G,B
        let red = CGFloat((rgbValue >> 16) & 0xff) / 255.0
        let green = CGFloat((rgbValue >> 08) & 0xff) / 255.0
        let blue = CGFloat((rgbValue >> 00) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
}

class Config : NSObject {
    
    
    
    let key : String
    let ref : FIRDatabaseReference?
    var active = true
    var facebook : String?
    var twitter : String?
    var pyconName : String?
    var pyconColor : UIColor
    var pyconLogo : UIImage?
    
    
    
    init(key : String, facebook : String, twitter : String, pyconName : String, pyconColor: UIColor, pyconLogo : UIImage) {
        self.key = key
        self.facebook = facebook
        self.twitter = twitter
        self.pyconName = pyconName
        self.pyconColor = pyconColor
        self.ref = nil
        self.pyconLogo = pyconLogo

    }
    
    
    
    
    init(snapshot : FIRDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        
        if let isActive = snapshot.value!["active"] as? Bool {
            active = isActive
        } else {
            active = true
        }
        
        if let fbName = snapshot.value!["facebook_mention"] as? String {
            facebook = fbName
        }
        
        
        if let twName = snapshot.value!["twitter_hashtag"] as? String {
            twitter = twName
        }
        
        
        if let pyName = snapshot.value!["pycon_name"] as? String {
            pyconName = pyName
        }
        
        if let color = snapshot.value!["pycon_color"] as? String {
            pyconColor = UIColor(hexString: color)
        } else {
            pyconColor = UIColor(hexString: "3773a5")
        }
        
        if let pyLogo = snapshot.value!["pycon_logo"] as? String {
            var urlString = pyLogo
            let url = urlString
            let urlImage = NSURL(string: url)
            let data = NSData(contentsOfURL: urlImage!)
            if let dataContent = data {
                pyconLogo = UIImage(data: dataContent)
            } else {
                
                pyconLogo = UIImage(named: "")
                
            }
            
        }
        
        
        
        
    }
    
    
}
