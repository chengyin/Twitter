//
//  TweetViewController.swift
//  Twitter
//
//  Created by chengyin_liu on 6/2/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var displayNameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!

  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var replyButton: UIButton!
  
  var tweet: Tweet!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.edgesForExtendedLayout = .None;

    retweetButton.imageView?.contentMode = .ScaleAspectFit
    likeButton.imageView?.contentMode = .ScaleAspectFit
    replyButton.imageView?.contentMode = .ScaleAspectFit
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    showTweet()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func showTweet() {
    tweetTextLabel?.text = tweet.text
    displayNameLabel.text = tweet.author.name
    handleLabel.text = tweet.author.formattedScreenName

    if (tweet.author.profileImageLargeURL != nil) {
      userImageView.af_setImageWithURL(NSURL(string: tweet.author.profileImageLargeURL!)!)
    }

    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    formatter.timeStyle = .ShortStyle
    timestampLabel.text = formatter.stringFromDate(tweet.createdAt)


    if (tweet.retweeted == true) {
      retweetButton.setImage(UIImage(named: "retweet-on"), forState: .Normal)
      retweetButton.setImage(UIImage(named: "retweet-on"), forState: .Highlighted)
      retweetButton.setTitleColor(UIColor(red:0.10, green:0.81, blue:0.53, alpha:1.00), forState: .Normal)
    } else {
      retweetButton.setImage(UIImage(named: "retweet"), forState: .Normal)
      retweetButton.setImage(UIImage(named: "retweet"), forState: .Highlighted)
      retweetButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }

    retweetButton.setTitle(" \(tweet.retweetCount)", forState: .Normal)
    retweetButton.sizeToFit()

    if (tweet.favorited == true) {
      likeButton.setImage(UIImage(named: "like-on"), forState: .Normal)
      likeButton.setImage(UIImage(named: "like-on"), forState: .Highlighted)
      likeButton.setTitleColor(UIColor(red:0.91, green:0.11, blue:0.31, alpha:1.00), forState: .Normal)
    } else {
      likeButton.setImage(UIImage(named: "like"), forState: .Normal)
      likeButton.setImage(UIImage(named: "like"), forState: .Highlighted)
      likeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }

    likeButton.setTitle(" \(tweet.favoriteCount)", forState: .Normal)
    likeButton.sizeToFit()
  }

  @IBAction func didTapRetweetButton(sender: AnyObject) {
    if (tweet.retweeted == true) {
      tweet.unretweet { (error) in
        self.showTweet()
      }
    } else {
      tweet.retweet { (error) in
        self.showTweet()
      }
    }
  }

  @IBAction func didTapLikeButton(sender: AnyObject) {
    if (tweet.favorited == true) {
      tweet.unfavorite({ (error) in
        self.showTweet()
      })
    } else {
      tweet.favorite({ (error) in
        self.showTweet()
      })
    }
  }

  @IBAction func didTapReplyButton(sender: AnyObject) {
    let composerVC = ComposerViewController()
    composerVC.delegate = self
    composerVC.inReplyToTweet = tweet
    TwitterClient.sharedInstance().currentUser() { user in
      composerVC.author = user
      self.presentViewController(composerVC, animated: true, completion: nil)
    }
  }

}

extension TweetViewController: ComposerViewControllerDelegate {
  func composerViewControllerDidSubmit(composerViewController: ComposerViewController, tweet: Tweet) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func composerViewControllerDidCancel(composerViewController: ComposerViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}