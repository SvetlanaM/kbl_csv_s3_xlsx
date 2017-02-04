//
//  PresentViewController.swift
//  PyCon CZ 2016
//
//  Created by Svetlana Margetová on 14.11.16.
//  Copyright © 2016 Svetlana Margetová. All rights reserved.
//

import UIKit
import SVProgressHUD

class PresentViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        DataManager.sharedInstance.setConfigDB({
            (data) -> Void in
            
            let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TalksViewController") as! TalksViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        })
        
        

        

        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
