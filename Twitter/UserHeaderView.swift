//
//  UserHeaderView.swift
//  Twitter
//
//  Created by chengyin_liu on 6/2/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit
import UIImageEffects

private let userBioWidth: CGFloat = 240.0
private let userHeaderDetailsHeight: CGFloat = 178.0
private let userHeaderDetailsContentHeight: CGFloat = 168.0

class UserHeaderDetailedInfoView: UIView {
  let bioLabel = UILabel()
  let locationLabel = UILabel()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    backgroundColor = nil
    tintColor = UIColor.whiteColor()

    bioLabel.numberOfLines = 0
    bioLabel.font = UIFont.systemFontOfSize(14)
    bioLabel.textColor = UIColor.whiteColor()
    bioLabel.textAlignment = .Center

    locationLabel.font = UIFont.systemFontOfSize(13)
    locationLabel.textColor = UIColor.whiteColor()

    self.addSubview(bioLabel)
    self.addSubview(locationLabel)
  }

  override func layoutSubviews() {
    let height = bounds.height
    let width = bounds.width

    bioLabel.bounds.size = CGSizeMake(userBioWidth, height)
    bioLabel.sizeToFit()
    locationLabel.sizeToFit()
    var y = (height - bioLabel.bounds.height - locationLabel.bounds.height) / 2

    bioLabel.frame.origin = CGPointMake((width - bioLabel.bounds.width) / 2, y)
    y += bioLabel.bounds.height + 8
    locationLabel.frame.origin = CGPointMake((width - locationLabel.bounds.width) / 2, y)
  }
}

private let userHeaderImageSize: CGFloat = 80.0

class UserHeaderBasicInfoView: UIView {
  let profileImageView = UIImageView()
  let displayNameLabel = UILabel()
  let handleLabel = UILabel()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    backgroundColor = nil
    tintColor = UIColor.whiteColor()

    profileImageView.bounds = CGRectMake(0, 0, userHeaderImageSize, userHeaderImageSize)
    profileImageView.layer.cornerRadius = 6
    profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
    profileImageView.layer.borderWidth = 2.0
    profileImageView.clipsToBounds = true

    displayNameLabel.font = UIFont.boldSystemFontOfSize(14)
    handleLabel.font = UIFont.systemFontOfSize(12)

    displayNameLabel.textColor = UIColor.whiteColor()
    handleLabel.textColor = UIColor.whiteColor()

    addSubview(profileImageView)
    addSubview(displayNameLabel)
    addSubview(handleLabel)
  }

  override func layoutSubviews() {
    var y: CGFloat = 16

    let width = bounds.width
    profileImageView.frame.origin = CGPointMake((width - userHeaderImageSize) / 2, y)

    y += userHeaderImageSize + 8
    displayNameLabel.sizeToFit()
    let displayNameLabelSize = displayNameLabel.frame.size
    displayNameLabel.frame.origin = CGPointMake((width - displayNameLabelSize.width) / 2, y)

    y += displayNameLabelSize.height
    handleLabel.sizeToFit()
    handleLabel.frame.origin = CGPointMake((width - handleLabel.frame.size.width) / 2, y)
  }
}

class UserHeaderView: UIView {

  private let backgroundImageView = UIImageView()
  let scrollView = UIScrollView()
  let pageControl = UIPageControl()

  var basicInfoView: UserHeaderBasicInfoView!
  var detailInfoView: UserHeaderDetailedInfoView!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    basicInfoView = UserHeaderBasicInfoView(coder: aDecoder)
    detailInfoView = UserHeaderDetailedInfoView(coder: aDecoder)

    scrollView.pagingEnabled = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.backgroundColor = nil

    scrollView.addSubview(basicInfoView)
    scrollView.addSubview(detailInfoView)

    backgroundImageView.contentMode = .ScaleAspectFill
    backgroundImageView.clipsToBounds = true

    addSubViewWithConstrains(backgroundImageView)
    addSubViewWithConstrains(scrollView)

    pageControl.numberOfPages = 2
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    addSubview(pageControl)

    let views = ["subView": pageControl];

    self.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[subView]-(8)-|",
        options: [],
        metrics: nil,
        views: views
      )
    )

    self.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[subView]|",
        options: [],
        metrics: nil,
        views: views
      )
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let frame = CGRectMake(0, 0, bounds.width, userHeaderDetailsHeight)
    scrollView.frame = frame

    let subviewFrames = CGRectMake(0, 0, bounds.width, userHeaderDetailsContentHeight)
    basicInfoView.frame = subviewFrames
    detailInfoView.frame = subviewFrames
    detailInfoView.frame.offsetInPlace(dx: scrollView.bounds.width, dy: 0)

    scrollView.contentSize = CGSizeMake(frame.width * 2, frame.height)

    backgroundImageView.frame = frame
  }

  func setBackgroundImage(image: UIImage) {
    backgroundImageView.image = image.applyExtraLightEffect()
  }

  func addSubViewWithConstrains(subView: UIView) {
    addSubview(subView)
    self.constrainView(subView)
  }

  func constrainView(view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false;
    let views = ["subView": view];

    self.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[subView]|",
        options: [],
        metrics: nil,
        views: views
      )
    )

    self.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[subView]|",
        options: [],
        metrics: nil,
        views: views
      )
    )
  }

  override func intrinsicContentSize() -> CGSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, userHeaderDetailsHeight)
  }
}
