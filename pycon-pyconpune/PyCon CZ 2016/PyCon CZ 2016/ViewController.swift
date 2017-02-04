//
//  ViewController.swift
//  PyCon CZ 2016
//
//  Created by Svetlana Margetová on 11.10.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootRef = FIRDatabase.database().reference()
        print (rootRef.key)
        
        let itemsRef = rootRef.child("pycon-630b8")
        print (itemsRef.key)
        
        let milkRef = itemsRef.child("a112")
        print (milkRef.key)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

