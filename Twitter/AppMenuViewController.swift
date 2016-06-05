//
//  AppMenuViewController.swift
//  Twitter
//
//  Created by chengyin_liu on 6/4/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

private struct Row {
  let label: String!
  let action: Selector!
}

protocol AppMenuViewControllerDelegate: class {
  func appMenuViewControllerDidTapTimeline(appMenuViewController: AppMenuViewController)
  func appMenuViewControllerDidTapMention(appMenuViewController: AppMenuViewController)
  func appMenuViewControllerDidTapProfile(appMenuViewController: AppMenuViewController)
}

class AppMenuViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  weak var delegate: AppMenuViewControllerDelegate?

  private let rows = [
    Row(label: "Timeline", action: #selector(AppMenuViewController.didTapTimeline)),
    Row(label: "Mentions", action: #selector(AppMenuViewController.didTapMention)),
    Row(label: "Profile", action: #selector(AppMenuViewController.didTapProfile))
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = UIColor.twtrOffWhiteColor()
    tableView.separatorColor = UIColor.twtrOffWhiteColor()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func didTapTimeline() {
    delegate?.appMenuViewControllerDidTapTimeline(self)
  }

  func didTapMention() {
    delegate?.appMenuViewControllerDidTapMention(self)
  }

  func didTapProfile() {
    delegate?.appMenuViewControllerDidTapProfile(self)
  }
}

extension AppMenuViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let row = rows[indexPath.row]
    let cell = UITableViewCell()

    cell.textLabel?.text = row.label
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = false;
    cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)

    return cell
  }
}

extension AppMenuViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    self.performSelector(rows[indexPath.row].action)
  }
}
