//
//  TwitterViewController.swift
//  PyCon CZ 2016
//
//  Created by Svetlana Margetová on 17.10.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import TwitterKit

class TwitterViewController: TWTRTimelineViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247/255.0, green: 249/255.0, blue: 252/255.0, alpha: 1.0)
        
        let client = TWTRAPIClient()
    }
    
    convenience init() {
        let client = TWTRAPIClient()
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: DataManager.sharedInstance.config.twitter!, APIClient: client)
        self.init(dataSource: dataSource)

        
        
        // Show Tweet actions
        self.showTweetActions = true
    }


}
