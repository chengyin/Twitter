//
//  AppViewController.swift
//  Twitter
//
//  Created by chengyin_liu on 5/31/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

class AppViewController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBar.barTintColor = UIColor.twtrBlueColor()
    navigationBar.tintColor = UIColor.whiteColor()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }

  func showChildViewController(childViewController: UIViewController) {
    pushViewController(childViewController, animated: true)
  }
}

extension AppViewController {
  override func canBecomeFirstResponder() -> Bool {
    return true
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    becomeFirstResponder()
  }

  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
    let alert = UIAlertController(title: "Log Out", message: "Are you sure?", preferredStyle: .Alert)

    alert.addAction(UIAlertAction(title: "Yes", style: .Destructive) { action in
      TwitterClient.sharedInstance().logOut()
    })

    alert.addAction(UIAlertAction(title: "Nah", style: .Cancel, handler: nil))

    presentViewController(alert, animated: true, completion: nil)
  }
}
