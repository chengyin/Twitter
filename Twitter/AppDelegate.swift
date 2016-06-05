//
//  AppDelegate.swift
//  Twitter
//
//  Created by chengyin_liu on 5/31/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import DateTools
import OAuthSwift

let URL_SCHEME_OAUTH = "cloauth"
let VER = 1.0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewControllerDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    let twitterClient = TwitterClient.sharedInstance()

    if (twitterClient.isLoggedIn()) {
      setAppVCAsRoot()
    } else {
      setLoginVCAsRoot()
    }

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.didLogOut), name: TwitterClient.EventLogOut, object: nil)

    return true
  }

  func setLoginVCAsRoot() {
    let vc = LoginViewController()
    vc.delegate = self
    window?.rootViewController = vc
  }

  func setAppVCAsRoot() {
    let vc = AppContainerViewController()
    window?.rootViewController = vc
  }

  func loginViewControllerDidLogIn(loginViewController: LoginViewController) {
    setAppVCAsRoot()
  }

  func didLogOut() {
    setLoginVCAsRoot()
  }

  func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    if (url.host == "oauth-callback") {
      let sourceAppKey = options["UIApplicationOpenURLOptionsSourceApplicationKey"] as? String
      
      if (sourceAppKey == "com.apple.SafariViewService" ||
        sourceAppKey == "com.apple.mobilesafari") {
        OAuthSwift.handleOpenURL(url)
      }
    }

    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }



}

extension UIColor {
  class func twtrBlueColor() -> UIColor {
    return UIColor(red:0.33, green:0.68, blue:0.94, alpha:1.00)
  }

  class func twtrOffBlackColor() -> UIColor {
    return UIColor(red:0.16, green:0.18, blue:0.20, alpha:1.00)
  }

  class func twtrDarkGrayColor() -> UIColor {
    return UIColor(red:0.40, green:0.46, blue:0.50, alpha:1.00)
  }

  class func twtrLightGrayColor() -> UIColor {
    return UIColor(red:0.80, green:0.84, blue:0.87, alpha:1.00)
  }

  class func twtrOffWhiteColor() -> UIColor {
    return UIColor(red:0.89, green:0.91, blue:0.93, alpha:1.00)
  }
}