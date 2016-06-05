//
//  User.swift
//  Twitter
//
//  Created by chengyin_liu on 5/31/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import Foundation

class User {
  var name: String!
  var bio: String?
  var profileImageURL: String?
  var profileImageLargeURL: String? {
    get {
      return profileImageURL?.stringByReplacingOccurrencesOfString("_normal", withString: "")
    }
  }
  var profileBannerURL: String?
  var profileBannerMobileURL: String! {
    get {
      return (profileBannerURL != nil) ? (profileBannerURL! + "/mobile_retina") : nil
    }
  }
  var screenName: String!
  var formattedScreenName: String? {
    get { return "@\(screenName)" }
  }
  var location: String?
  
  var followersCount: Int!
  var followingsCount: Int!
  var statusesCount: Int!

  init(json: [String: AnyObject]) {
    name = json["name"] as? String
    profileImageURL = json["profile_image_url_https"] as? String
    profileBannerURL = json["profile_banner_url"] as? String
    screenName = json["screen_name"] as? String
    bio = json["description"] as? String
    location = json["location"] as? String
    statusesCount = json["statuses_count"] as? Int
    followersCount = json["followers_count"] as? Int
    followingsCount = json["friends_count"] as? Int
  }
}