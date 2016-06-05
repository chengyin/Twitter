//
//  Tweet.swift
//  Twitter
//
//  Created by chengyin_liu on 5/31/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import Foundation

class Tweet {
  var id: String? = nil
  var text: String = ""
  var author: User!
  var createdAt: NSDate!
  var retweeted: Bool!
  var favorited: Bool!

  var retweetCount: Int!
  var favoriteCount: Int!

  init(id: String? = nil, text: String, author: User, createdAt: NSDate) {
    self.id = id
    self.text = text
    self.author = author
    self.createdAt = createdAt
  }

  init(json: [String: AnyObject]) {
    setValuesWithJSON(json)
  }

  func setValuesWithJSON(json: [String: AnyObject]) {
    id = json["id_str"] as? String
    text = json["text"] as? String ?? ""
    createdAt = TwitterClient.formatDateString(json["created_at"] as! String)
    author = User(json: json["user"] as! [String: AnyObject])
    retweeted = json["retweeted"] as? Bool ?? false
    favorited = json["favorited"] as? Bool ?? false
    retweetCount = json["retweet_count"] as? Int ?? 0
    favoriteCount = json["favorite_count"] as? Int ?? 0
  }

  func handleServerResponse(error: NSError?, data: NSData?, response:NSHTTPURLResponse?, completion: (error: NSError?) -> Void) {
    if (error != nil) {
      completion(error: error)
    } else {
      if let json = try! NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [String: AnyObject] {
        self.setValuesWithJSON(json)
        completion(error: nil)
      }
    }
  }

  func save(inReplyToId: String? = nil, completion: (error: NSError?) -> Void) {
    if (self.id == nil && !self.text.isEmpty) {
      var parameters = ["status": text]

      if (inReplyToId != nil) {
        parameters["in_reply_to_status_id"] = inReplyToId
      }

      TwitterClient.sharedInstance().sendRequest(
        .POST,
        endpoint: "statuses/update.json",
        parameters: parameters
      ) { (error, data, response) in
          self.handleServerResponse(error, data: data, response: response, completion: completion)
      }
    }
  }

  func retweet(completion: (error: NSError?) -> Void) {
    TwitterClient.sharedInstance().sendRequest(
      .POST,
      endpoint: "statuses/retweet/\(id!).json",
      parameters: nil
    ) { (error, data, response) in
      self.retweeted = true
      self.retweetCount! += 1
      completion(error: error)
    }

  }

  func unretweet(completion: (error: NSError?) -> Void) {
    TwitterClient.sharedInstance().sendRequest(
      .POST,
      endpoint: "statuses/unretweet/\(id!).json",
      parameters: nil
    ) { (error, data, response) in
      self.retweeted = false
      self.retweetCount! -= 1
      completion(error: error)
    }
  }

  func favorite(completion: (error: NSError?) -> Void) {
    TwitterClient.sharedInstance().sendRequest(
      .POST,
      endpoint: "favorites/create.json",
      parameters: [
        "id": id!
      ]
    ) { (error, data, response) in
      self.favorited = true
      self.favoriteCount! += 1
      completion(error: error)
    }
  }

  func unfavorite(completion: (error: NSError?) -> Void) {
    TwitterClient.sharedInstance().sendRequest(
      .POST,
      endpoint: "favorites/destory.json",
      parameters: [
        "id": id!
      ]
    ) { (error, data, response) in
      self.favorited = false
      self.favoriteCount! -= 1
      completion(error: error)
    }
  }

}

extension Tweet {
  class func tweetsWithJSONArray(array: [AnyObject]) -> [Tweet] {
    return array.map { t in
      return Tweet(json: t as! [String : AnyObject])
    }
  }

  class func loadTweets(endpoint: String, sinceId: String? = nil, maxId: String? = nil, completion: (tweets: [Tweet]?, error: ErrorType?) -> Void) {
    let client = TwitterClient.sharedInstance()
    var parameters: [String: AnyObject] = [:]

    if (sinceId != nil) {
      parameters["since_id"] = sinceId
    }

    if (maxId != nil) {
      parameters["max_id"] = maxId
    }

    client.sendRequest(
      .GET,
      endpoint: endpoint,
      parameters: parameters) {
        (error, data, response) in
        if (error != nil) {
          print(error)
          completion(tweets: nil, error: error)
          return
        }

        if let responseArray = try! NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [AnyObject] {
            let tweets = tweetsWithJSONArray(responseArray)
            completion(tweets: tweets, error: nil)
        }
    }
  }

  class func loadUserTimeline(completion: (tweets: [Tweet]?, error: ErrorType?) -> Void) {
    Tweet.loadTweets("statuses/user_timeline.json", completion: completion)
  }

  class func loadHomeTimeline(sinceId: String? = nil, maxId: String? = nil, completion: (tweets: [Tweet]?, error: ErrorType?) -> Void) {
    Tweet.loadTweets("statuses/home_timeline.json", sinceId: sinceId, maxId: maxId, completion: completion)
  }

  class func loadMentionsTimeline(completion: (tweets: [Tweet]?, error: ErrorType?) -> Void) {
    Tweet.loadTweets("statuses/mentions_timeline.json", completion: completion)
  }
}
