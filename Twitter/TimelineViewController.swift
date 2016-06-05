//
//  TimelineViewController.swift
//  Twitter
//
//  Created by chengyin_liu on 5/31/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

let TWEET_TABLE_VIEW_CELL_ID = "tweetTableViewCell"

class TimelineViewController:
  UIViewController,
  UITableViewDataSource,
  ComposerViewControllerDelegate {

  var tableView = UITableView()
  weak var delegate: AppContainerViewControllerProtocol?

  var tweets: [Tweet] = []
  let refreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()

    let subView = tableView
    let parentView = view

    subView.translatesAutoresizingMaskIntoConstraints = false;
    parentView.addSubview(subView)

    let views = ["subView": subView];

    parentView.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[subView]|",
        options: [],
        metrics: nil,
        views:views
      )
    )

    parentView.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[subView]|",
        options: [],
        metrics: nil,
        views:views
      )
    )

    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 60.0

    let nib = UINib(nibName: "TweetTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: TWEET_TABLE_VIEW_CELL_ID)

    refreshControl.addTarget(self, action: #selector(TimelineViewController.didTriggerRefresh), forControlEvents: .ValueChanged)
    tableView.addSubview(refreshControl)

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(TimelineViewController.didTapCompose))

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: #selector(TimelineViewController.didTapMenu))

    loadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func loadData() {
    Tweet.loadHomeTimeline { (tweets, error) in
      self.tweets = tweets ?? []
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
    }
  }

  func loadOlderData() {
    Tweet.loadHomeTimeline(maxId: self.tweets.last?.id) { (tweets, error) in
      self.tweets.appendContentsOf(tweets ?? [])
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(TWEET_TABLE_VIEW_CELL_ID, forIndexPath: indexPath) as! TweetTableViewCell
    let row = indexPath.row
    let tweet = tweets[row]

    cell.tweetTextLabel?.text = tweet.text
    cell.displayNameLabel.text = tweet.author.name
    cell.handleLabel.text = tweet.author.formattedScreenName
    cell.timestampLabel.text = tweet.createdAt.shortTimeAgoSinceNow()

    if (tweet.author.profileImageLargeURL != nil) {
      cell.userImageView.imageView.af_setImageWithURL(NSURL(string: tweet.author.profileImageLargeURL!)!)
    }

    cell.delegate = self

    if (row == tweets.count - 5 && tweets.count > 19) {
      loadOlderData()
    }

    return cell
  }

  func didTriggerRefresh() {
    loadData()
  }

  func didTapCompose() {
    let vc = ComposerViewController()
    vc.delegate = self

    TwitterClient.sharedInstance().currentUser { (user) in
      vc.author = user
      self.presentViewController(vc, animated: true, completion: nil)
    }
  }

  func didTapMenu() {
    delegate?.toggleLeftPanel()
  }

  func composerViewControllerDidCancel(composerViewController: ComposerViewController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  func composerViewControllerDidSubmit(composerViewController: ComposerViewController, tweet: Tweet) {
    self.tweets.insert(tweet, atIndex: 0)
    self.tableView.reloadData()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

// MARK: - UITableViewDelegate functions

extension TimelineViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    let tweet = self.tweets[indexPath.row]
    let vc = TweetViewController()
    vc.tweet = tweet
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - TweetTableViewCellDelegate functions

extension TimelineViewController: TweetTableViewCellProtocol {
  func tweetTableViewCellDidTapOnUserImage(tweetTableViewCell: TweetTableViewCell) {
    let indexPath = tableView.indexPathForCell(tweetTableViewCell)

    if (indexPath != nil) {
      let tweet = tweets[indexPath!.row]
      let author = tweet.author

      let vc = UserViewNavController()
      vc.user = author

      presentViewController(vc, animated: true, completion: nil)
    }
  }
}