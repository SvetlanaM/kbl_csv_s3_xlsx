//
//  Model.swift
//  PyCon CZ 2016
//
//  Created by Svetlana Margetová on 14.10.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DataManager {
    
    static let sharedInstance = DataManager()
    var dbRef : FIRDatabaseReference!
    var rooms = [Room]()
    var talks = [Talk]()
    var config = Config(key: "", facebook: "", twitter: "", pyconName: "", pyconColor: UIColor(), pyconLogo: UIImage())
    
    
    func setConfigDB(configData : (Config -> Void)) {
        self.dbRef = FIRDatabase.database().reference()
        
        //editable pycon item
        let pyconRef = dbRef.child("pycon_pune2017")
        let dbMain = pyconRef.child("main")
        let dbConfig = dbMain.child("config")
        dbConfig.observeEventType(.Value, withBlock: {( snapshot:FIRDataSnapshot) in
            let configObject = Config(snapshot: snapshot as! FIRDataSnapshot)
            self.config = configObject
            configData(configObject)
        })
        {(error : NSError) in
            print(error.description)
        }
        
    }
    
    func setDB(roomData : (Room -> Void)) {
        self.dbRef = FIRDatabase.database().reference()
        
        
        //editable pycon item
        let pyconRef = dbRef.child("pycon_pune2017")
        let roomConfig = pyconRef.child("rooms")
        roomConfig.observeEventType(.Value, withBlock: {( snapshot:FIRDataSnapshot) in
            self.rooms = []
            for room in snapshot.children {
                
                let roomObject = Room(snapshot: room as! FIRDataSnapshot)
                self.rooms.append(roomObject)
                roomData(roomObject)
                
                
            }
        }) {(error : NSError) in
            print(error.description)
            }
        }
    
    func setTalkDB(room : Room, talkData : ([Talk] -> Void)) {
        self.dbRef = FIRDatabase.database().reference()
        
        //editable pycon item
        let pyconRef = dbRef.child("pycon_pune2017")
        let roomConfig = pyconRef.child("rooms")

            
            
            if let roomName = room.key {
                
                let talkConfig = roomConfig.child(roomName)
                talkConfig.observeEventType(.Value, withBlock: {( snapshot:FIRDataSnapshot) in
                    
                    
                    for talk in snapshot.children {
                        
                        let talkObject = Talk(snapshot: talk as! FIRDataSnapshot)
                        self.talks.append(talkObject)
                        talkData([talkObject])
                        room.talks.append(talkObject)
                        
                        
                    }
                    
                    
                    
                })
                {(error : NSError) in
                    print(error.description)
                }
            }
            
            
           
        }
        
        
        
    }
    
    
    
    



