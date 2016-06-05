//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by chengyin_liu on 5/31/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit
import AlamofireImage

protocol TweetTableViewCellProtocol: class {
  func tweetTableViewCellDidTapOnUserImage(tweetTableViewCell: TweetTableViewCell)
}

class TweetTableViewCell: UITableViewCell {

  @IBOutlet weak var userImageView: UserImageView!
  @IBOutlet weak var displayNameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!

  weak var delegate: TweetTableViewCellProtocol?

  override func awakeFromNib() {
    super.awakeFromNib()

    let view = UIView()
    view.backgroundColor = UIColor.twtrOffWhiteColor()
    selectedBackgroundView = view

    userImageView.addTarget(self, action: #selector(TweetTableViewCell.didTapUserImage))
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func didTapUserImage(sender: AnyObject) {
    self.delegate?.tweetTableViewCellDidTapOnUserImage(self)
  }

}
