//
//  TalksViewController.swift
//  PyCon CZ 2016
//
//  Created by Svetlana Margetová on 15.10.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Social
import SVProgressHUD

extension UISegmentedControl {
    func replaceSegments(segments: Array<Room>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegmentWithTitle(segment.key, atIndex: self.numberOfSegments, animated: false)
        }
    }
}

class TalksViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var talks = [Talk]()
    var rooms = [Room]()
    var twitter : String?
    var mainColor : UIColor?
    
    @IBOutlet weak var segmentView: UIView!
    var collection : UICollectionView?
    var infoLabel : UILabel?
    var imageV : UIImageView?
    
    @IBOutlet var mainView: UIView!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        mainView.backgroundColor = .whiteColor()
        self.imageV = UIImageView(frame:CGRectMake((self.view.frame.width/2)-100, ((self.view.frame.height-80)/2)-100, 200, 200))
        
        
        self.imageV?.image = UIImage(named: "progress")
        self.imageV?.contentMode = .ScaleAspectFit
        self.imageV?.clipsToBounds = true
        self.view.addSubview(imageV ?? UIImageView())
        
        self.segmentControl.hidden = true
        
        
        
        
        
        
        
        DataManager.sharedInstance.setConfigDB({
            
            (data) -> Void in
            SVProgressHUD.show()
            self.navigationController?.navigationBar.barTintColor = DataManager.sharedInstance.config.pyconColor
            self.navigationItem.title = DataManager.sharedInstance.config.pyconName
        self.segmentView.backgroundColor = DataManager.sharedInstance.config.pyconColor
        self.twitter = DataManager.sharedInstance.config.twitter
        self.mainColor = DataManager.sharedInstance.config.pyconColor
            // Layout setup
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 170, right: 0)
            self.collection = UICollectionView(frame: CGRectMake(0, 80, self.view.frame.width, self.view.frame.height), collectionViewLayout: layout)
            self.collection?.delegate = self
            self.collection?.dataSource = self
            self.collection?.registerClass(TalkCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            self.view.addSubview(self.collection!)
            self.collection?.backgroundColor = UIColor(red: 246/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
            
            self.segmentControl.hidden = false
            
            
            })
        
        
        DataManager.sharedInstance.setDB { (roomData) in
            
            
            self.segmentControl.replaceSegments(DataManager.sharedInstance.rooms)
            DataManager.sharedInstance.setTalkDB(roomData, talkData: { (talkData) in
                self.getInitialData()
                SVProgressHUD.dismiss()
            })
            }
        
        
        delay(3.5) {self.isConnected { (state) in
            
            if state == false {
                let alert = UIAlertController(title: "Network Error", message: "Worse data connection. You have local data still accesible.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            }
        }
        }
    
    
    func isConnected(state : (Bool -> Void)) {
        let connectedRef = FIRDatabase.database().referenceWithPath(".info/connected")
        connectedRef.observeEventType(.Value, withBlock: { snapshot in
            if let connected = snapshot.value as? Bool where connected {
                if connected == true {
                    
                    state(true)
                    
                }
            } else {
                
                    state(false)
                
            }
        })
    }
    

    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    @IBAction func shareOnTwitter(sender: UIBarButtonItem) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if let twitterName = self.twitter {
                twitterSheet.setInitialText(twitterName)
            }
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func getRoom(key : String) -> Room {
        
        for i in DataManager.sharedInstance.rooms {
            if i.key == key {
                return i
            }
        }
        return Room(key: key)
    }
    
    func getInitialData() {
        var title = segmentControl.titleForSegmentAtIndex(0)
        
        
        if let titleU = title {
            var room = getRoom(titleU)
            print (room.talks.count)
            self.talks = []
            self.talks = room.talks
            
        }
        
        self.collection?.reloadData()
        SVProgressHUD.dismiss()
    }
    
    @IBAction func changeRoom(sender: AnyObject) {
        var sCount = segmentControl.numberOfSegments
        for i in 0..<sCount + 1 {
            if (segmentControl.selectedSegmentIndex == i) {
                var title = segmentControl.titleForSegmentAtIndex(i)
                if let titleU = title {
                    var room = getRoom(titleU)
                    self.talks = []
                    self.talks = room.talks
                }
                self.collection?.reloadData()
                
            
            }
            
        }
    }
    
    // collection view cell setup
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? TalkCollectionViewCell
        
        if let collCell = cell {
            collCell.backgroundColor = .whiteColor()
            collCell.layer.cornerRadius = 10
            collCell.contentView.layer.cornerRadius = 2.0;
            collCell.contentView.layer.borderWidth = 1.0;
            collCell.contentView.layer.borderColor = UIColor.clearColor().CGColor;
            collCell.contentView.layer.masksToBounds = true;
            collCell.layer.shadowColor = UIColor(red: 205/255.0, green: 209/255.0, blue: 213/255.0, alpha: 1.0).CGColor
            collCell.layer.shadowOffset = CGSizeMake(0, 4.0);
            collCell.layer.shadowRadius = 5.0;
            collCell.layer.shadowOpacity = 1.0;
            collCell.layer.masksToBounds = false;
            collCell.layer.shadowPath = UIBezierPath(roundedRect:cell!.bounds, cornerRadius:cell!.contentView.layer.cornerRadius).CGPath;
            collCell.configureCell(talks[indexPath.row])
            return collCell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
            return talks.count
        
    }
    
    func collectionView(collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section : Int) -> CGFloat {
        return 20.5
    }
    
    func collectionView(collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section : Int) -> CGFloat {
        return 20.5
    }
    
    func collectionView(collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width-50, height: 120)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        
            if talks[indexPath.row].type == "event" {
                cell?.selected = false
            } else {
                
                cell?.selected = true
                
                let vc = TalkDetailViewController()
                vc.talk = talks[indexPath.row]
                self.navigationController?.showViewController(vc, sender: self)
            }
        }
}
