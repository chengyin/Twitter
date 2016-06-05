//
//  UserViewController.swift
//  Twitter
//
//  Created by chengyin_liu on 6/2/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class UserViewController: UIViewController {

  weak var delegate: AppContainerViewControllerProtocol?

  @IBOutlet weak var userHeaderView: UserHeaderView!

  @IBOutlet weak var tweetsLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var followingsLabel: UILabel!

  var isInAppContainer = false

  let downloader = ImageDownloader()

  var user: User!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.edgesForExtendedLayout = .None

    if (isInAppContainer) {
      navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: #selector(UserViewController.didTapMenu))
    } else {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(UserViewController.didTapCancel))
    }

    userHeaderView.basicInfoView.displayNameLabel.text = user.name
    userHeaderView.basicInfoView.handleLabel.text = user.formattedScreenName
    userHeaderView.basicInfoView.profileImageView.af_setImageWithURL(NSURL(string: user.profileImageLargeURL!)!)

    userHeaderView.detailInfoView.bioLabel.text = user.bio
    userHeaderView.detailInfoView.locationLabel.text = user.location

    if (user.profileBannerMobileURL != nil) {
      let URLRequest = NSURLRequest(URL: NSURL(string: user.profileBannerMobileURL!)!)

      downloader.downloadImage(URLRequest: URLRequest) { response in
        if let image = response.result.value {
          self.userHeaderView.setBackgroundImage(image)
        }
      }
    }

    tweetsLabel.text = String(user.statusesCount)
    followersLabel.text = String(user.followersCount)
    followingsLabel.text = String(user.followingsCount)
  }

  func didTapCancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func didTapMenu() {
    delegate?.toggleLeftPanel()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

class UserViewNavController: UINavigationController {
  private var contentVC: UserViewController!
  var user: User!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationBar.translucent = false
    navigationBar.barTintColor = UIColor.twtrBlueColor()
    navigationBar.tintColor = UIColor.whiteColor()

    contentVC = UserViewController()
    contentVC.user = user

    setViewControllers([contentVC], animated: false)
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}
