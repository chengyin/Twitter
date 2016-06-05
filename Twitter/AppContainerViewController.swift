//
//  AppContainerViewController.swift
//  Twitter
//
//  Created by chengyin_liu on 6/4/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

protocol AppContainerViewControllerProtocol: class {
  func toggleLeftPanel()
}

class AppContainerViewController: UIViewController {

  var centerViewController: AppViewController!
  var timelineViewController: TimelineViewController!
  var mentionsViewController: MentionsViewController!
  var profileViewController: UserViewController!

  let centerPanelExpandedOffset: CGFloat = 60


  var isLeftPanelExpanded = false {
    didSet {
      showShadowForCenterViewController(isLeftPanelExpanded)
    }
  }

  var leftViewController: AppMenuViewController!

  override func viewDidLoad() {
    super.viewDidLoad()
    centerViewController = AppViewController()

    timelineViewController = TimelineViewController()
    timelineViewController.delegate = self
    centerViewController.setViewControllers([timelineViewController], animated: false)

    view.addSubview(centerViewController.view)
    centerViewController.view.frame = view.bounds
    addChildViewController(centerViewController)

    centerViewController.didMoveToParentViewController(self)

    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(AppContainerViewController.handlePanGesture(_:)))
    centerViewController.view.addGestureRecognizer(panGestureRecognizer)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }

  func showShadowForCenterViewController(shouldShowShadow: Bool) {
    if (shouldShowShadow) {
      centerViewController.view.layer.shadowOpacity = 0.5
    } else {
      centerViewController.view.layer.shadowOpacity = 0.0
    }
  }

  func handlePanGesture(recognizer: UIPanGestureRecognizer) {
    let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)

    switch(recognizer.state) {
    case .Began:
      if (!isLeftPanelExpanded) {
        if (gestureIsDraggingFromLeftToRight) {
          addLeftPanelViewController()
        }

        showShadowForCenterViewController(true)
      }
    case .Changed:
      if (gestureIsDraggingFromLeftToRight || isLeftPanelExpanded) {
        recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
        recognizer.setTranslation(CGPointZero, inView: view)
      }
    case .Ended:
      if (leftViewController != nil) {
        // animate the side panel open or closed based on whether the view has moved more or less than halfway
        let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
        animateLeftPanel(hasMovedGreaterThanHalfway)
      }
    default:
      break
    }
  }

  func addLeftPanelViewController() {
    if (leftViewController == nil) {
      leftViewController = AppMenuViewController()
      leftViewController.view.frame = CGRectMake(0, 20, view.bounds.width, view.bounds.height - 20)
      leftViewController.delegate = self
    }

    view.insertSubview(leftViewController.view, atIndex: 0)
    addChildViewController(leftViewController)
    leftViewController.didMoveToParentViewController(self)
  }
}

extension AppContainerViewController: AppContainerViewControllerProtocol {

  func toggleLeftPanel() {
    addLeftPanelViewController()
    animateLeftPanel(!isLeftPanelExpanded)
  }

  func animateLeftPanel(shouldExpand: Bool) {
    if (shouldExpand) {
      isLeftPanelExpanded = true

      animateCenterPanelXPosition(
        CGRectGetWidth(centerViewController
        .view.frame) - centerPanelExpandedOffset
      )
    } else {
      animateCenterPanelXPosition(0) { finished in
        self.isLeftPanelExpanded = false

        self.leftViewController!.view.removeFromSuperview()
        self.leftViewController = nil;
      }
    }
  }

  func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
    UIView.animateWithDuration(
      0.5,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: .CurveEaseInOut,
      animations: {
        self.centerViewController.view.frame.origin.x = targetPosition
      },
      completion: completion
    )
  }
}

extension AppContainerViewController: AppMenuViewControllerDelegate {
  func appMenuViewControllerDidTapTimeline(appMenuViewController: AppMenuViewController) {
    centerViewController.setViewControllers([timelineViewController], animated: false)
    toggleLeftPanel()
  }

  func appMenuViewControllerDidTapMention(appMenuViewController: AppMenuViewController) {
    if (mentionsViewController == nil) {
      mentionsViewController = MentionsViewController()
      mentionsViewController.delegate = self
    }

    centerViewController.setViewControllers([mentionsViewController], animated: false)
    toggleLeftPanel()
  }

  func appMenuViewControllerDidTapProfile(appMenuViewController: AppMenuViewController) {
    if (profileViewController == nil) {
      profileViewController = UserViewController()
      profileViewController.isInAppContainer = true
      profileViewController.delegate = self
    }

    TwitterClient.sharedInstance().currentUser { (user) in
      self.profileViewController.user = user
      self.centerViewController.setViewControllers([self.profileViewController], animated: false)
    }

    toggleLeftPanel()
  }
}