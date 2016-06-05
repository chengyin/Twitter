//
//  UserImageView.swift
//  Twitter
//
//  Created by chengyin_liu on 6/2/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

class UserImageView: UIView {
  var imageView: UIImageView!

  weak private var target: AnyObject?
  private var action: Selector?

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    layer.cornerRadius = 3.0
    clipsToBounds = true
    
    imageView = UIImageView()
    imageView.userInteractionEnabled = true
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserImageView.handleTap))

    let parentView = self
    let subView = imageView
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

    imageView.addGestureRecognizer(tapRecognizer)
  }

  func handleTap() {
    target?.performSelector(action!, withObject: self)
  }

  func addTarget(target: AnyObject, action: Selector) {
    self.target = target
    self.action = action
  }
}
