//
//  LoginViewController.swift
//  Twitter
//
//  Created by chengyin_liu on 5/31/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit
import TwitterKit

protocol LoginViewControllerDelegate: class {
  func loginViewControllerDidLogIn(loginViewController: LoginViewController)
}

class LoginViewController: UIViewController {

  @IBOutlet weak var loginButton: UIButton!
  weak var delegate: LoginViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    loginButton.layer.cornerRadius = 3
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func didTapLoginButton(sender: AnyObject) {
    TwitterClient.sharedInstance().logIn() { error in
      if (error == nil) {
        self.delegate?.loginViewControllerDidLogIn(self)
      }
    }
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
