//
//  TwitterClient.swift
//  Twitter
//
//  Created by chengyin_liu on 5/31/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import Foundation
import OAuthSwift

private let TWITTER_API_ROOT_URL = "https://api.twitter.com/1.1/"

private enum UserDefaultsKey: String {
  case UserId = "userId"
  case Token = "oauthToken"
  case TokenSecret = "oauthTokenSecret"
}

class TwitterClient {
  static let EventLogIn = "tc_event_log_in"
  static let EventLogOut = "tc_event_log_out"

  private static var _sharedInstance: TwitterClient!

  class func sharedInstance() -> TwitterClient {
    if (_sharedInstance == nil) {
      _sharedInstance = TwitterClient()
    }

    return _sharedInstance
  }

  let oauth: OAuth1Swift!
  private var _currentUser: User? = nil

  init() {
    oauth = OAuth1Swift(
      consumerKey:    "a8T3dHTEfP8YPsFnAI7psTZJY",
      consumerSecret: "dvJSidyojibI7IZz4N0i8qCES7w30VE7dE8hzGDG8sFBv0Xf2O",
      requestTokenUrl: "https://api.twitter.com/oauth/request_token",
      authorizeUrl:    "https://api.twitter.com/oauth/authorize",
      accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
    )

    if let credential = TwitterClient.savedCredential() {
      oauth.client.credential.oauth_token = credential.oauth_token
      oauth.client.credential.oauth_token_secret = credential.oauth_token_secret
    }
  }
}

extension TwitterClient {
  func logIn(completion: (error: NSError?) -> Void) {
    oauth.authorize_url_handler = SafariURLHandler(viewController: (UIApplication.sharedApplication().keyWindow?.rootViewController!)!)
    oauth.authorizeWithCallbackURL(
      NSURL(string: "\(URL_SCHEME_OAUTH)://oauth-callback/twitter")!,
      success: { (credential, response, parameters) in
        print(parameters)
        self.saveSessionWithCredential(credential, parameters: parameters)
        NSNotificationCenter.defaultCenter().postNotificationName(TwitterClient.EventLogIn, object: nil)
        completion(error: nil)
      },
      failure: { (error) in
        print(error)
        completion(error: error)
      }
    )

  }

  func logOut() {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.removeObjectForKey(UserDefaultsKey.UserId.rawValue)
    userDefaults.removeObjectForKey(UserDefaultsKey.Token.rawValue)
    userDefaults.removeObjectForKey(UserDefaultsKey.TokenSecret.rawValue)

    oauth.client.credential.oauth_token = ""
    oauth.client.credential.oauth_token_secret = ""

    _currentUser = nil

    NSNotificationCenter.defaultCenter().postNotificationName(TwitterClient.EventLogOut, object: nil)
  }

  func isLoggedIn() -> Bool {
    let credential = oauth.client.credential

    return !credential.oauth_token_secret.isEmpty
  }

  func currentUser(completion: (user: User?) -> Void) {
    if (_currentUser != nil) {
      completion(user: _currentUser)
      return
    }

    let userDefaults = NSUserDefaults.standardUserDefaults()
    let userId = userDefaults.stringForKey(UserDefaultsKey.UserId.rawValue)

    if (userId == nil) {
      completion(user: nil)
    } else {
      sendRequest(
        .GET,
        endpoint: "users/show.json",
        parameters: ["user_id": userId!],
        completion: { (error, data, response) in
          if (error != nil) {
            print(error)
            completion(user: nil)
          } else {
            if let responseHash = try! NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [String: AnyObject] {
              let user = User(json: responseHash)
              self._currentUser = user
              completion(user: user)
            }
          }
      })
    }
  }
}

extension TwitterClient {
  func sendRequest(method: OAuthSwiftHTTPRequest.Method, endpoint: String, parameters: [String: AnyObject]?, completion: (error: NSError?, data: NSData?, response: NSHTTPURLResponse?) -> Void) {
    let url = "\(TWITTER_API_ROOT_URL)\(endpoint)"
    
    oauth.client.request(
      url,
      method: method,
      parameters: parameters ?? [:],
      headers: nil,
      checkTokenExpiration: false,
      success: { (data, response) in
        completion(error: nil, data: data, response: response)
      }) { (error) in
        completion(error: error, data: nil, response: nil)
    }
  }
}

extension TwitterClient {
  private static func savedCredential() -> OAuthSwiftCredential? {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let token = userDefaults.stringForKey(UserDefaultsKey.Token.rawValue)
    let secret = userDefaults.stringForKey(UserDefaultsKey.TokenSecret.rawValue)

    if (token != nil && secret != nil) {
      return OAuthSwiftCredential(oauth_token: token!, oauth_token_secret: secret!)
    } else {
      return nil
    }
  }

  private func saveSessionWithCredential(credential: OAuthSwiftCredential, parameters: [String: String]) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setObject(parameters["user_id"], forKey: UserDefaultsKey.UserId.rawValue)
    userDefaults.setObject(credential.oauth_token, forKey: UserDefaultsKey.Token.rawValue)
    userDefaults.setObject(credential.oauth_token_secret, forKey: UserDefaultsKey.TokenSecret.rawValue)
  }
}

extension TwitterClient {
  class func formatDateString(dateString: String) -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy";

    return dateFormatter.dateFromString(dateString)
  }
}