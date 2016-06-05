//
//  MentionsViewController.swift
//  Twitter
//
//  Created by chengyin_liu on 6/4/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

class MentionsViewController: TimelineViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func loadData() {
    Tweet.loadMentionsTimeline { (tweets, error) in
      self.tweets = tweets ?? []
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
    }
  }
}
