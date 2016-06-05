//
//  ComposerViewController.swift
//  Twitter
//
//  Created by chengyin_liu on 6/1/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

protocol ComposerViewControllerDelegate: class {
  func composerViewControllerDidCancel(composerViewController: ComposerViewController)
  func composerViewControllerDidSubmit(composerViewController: ComposerViewController, tweet: Tweet)
}

class ComposerViewController: UIViewController {

  let maxCharacterCount = 140

  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var tweetTextView: UITextView!
  @IBOutlet weak var cancelButton: UIButton!

  @IBOutlet weak var characterCountLabel: UILabel!

  var author: User!
  var inReplyToTweet: Tweet? = nil

  var isShowingPlaceholder = true {
    didSet {
      adjustPlaceholder()
    }
  }

  weak var delegate: ComposerViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.bindToKeyboard()
    tweetTextView.delegate = self
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    userImageView.af_setImageWithURL(NSURL(string: author.profileImageLargeURL!)!)

    if (inReplyToTweet != nil) {
      let replyToUsername = inReplyToTweet!.author.formattedScreenName
      isShowingPlaceholder = false
      tweetTextView.text = replyToUsername! + " "
    } else {
      isShowingPlaceholder = true
    }

    updateCharacterCount()
    tweetTextView.becomeFirstResponder()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func didTapCancelButton(sender: AnyObject) {
    self.delegate?.composerViewControllerDidCancel(self)
  }

  @IBAction func didTapTweetButton(sender: AnyObject) {
    let tweet = Tweet(
      id: nil,
      text: tweetTextView.text,
      author: author,
      createdAt: NSDate()
    )

    tweet.save(inReplyToTweet?.id) { (error) in
      if (error != nil) {
        print(error)
      } else {
        self.delegate?.composerViewControllerDidSubmit(self, tweet: tweet)
      }
    }
  }

  func adjustPlaceholder() {
    if (isShowingPlaceholder) {
      tweetTextView.text = "What's Happening?"
      tweetTextView.textColor = UIColor.twtrLightGrayColor()
    } else {
      tweetTextView.text = ""
      tweetTextView.textColor = UIColor.twtrOffBlackColor()
    }
  }

  func updateCharacterCount() {
    let count = isShowingPlaceholder ? 0 : tweetTextView.text.utf8.count
    let remaining = maxCharacterCount - count

    characterCountLabel.text = String(remaining)
    characterCountLabel.textColor = remaining > 0 ? UIColor.twtrLightGrayColor() : UIColor.redColor()
  }
}

extension ComposerViewController: UITextViewDelegate {
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    if (isShowingPlaceholder) {
      isShowingPlaceholder = false
    }

    return true
  }

  func textViewDidChange(textView: UITextView) {
    updateCharacterCount()
  }

  func textViewDidEndEditing(textView: UITextView) {
    if (textView.text.isEmpty) {
      isShowingPlaceholder = true
    }
  }
}

extension ComposerViewController {
  func bindToKeyboard(){
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposerViewController.keyboardWillChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
  }


  func keyboardWillChange(notification: NSNotification) {
    let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
    let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
    let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
    let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    let deltaY = targetFrame.origin.y - curFrame.origin.y

    UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
      self.view.frame.size.height += deltaY
      },completion: nil)

  }
}