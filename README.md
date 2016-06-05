# Twitter

![GIF](./twitter.gif)

Submitted by: Chengyin Liu

Time spent: 25 hours

## Requirements

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- Hamburger menu
  - [x] Dragging anywhere in the view should reveal the menu.
  - [x] The menu should include links to your profile, the home timeline, and the mentions view.
  - [x] The menu can look similar to the menu below or feel free to take liberty with the UI.
- Profile page
  - [x] Contains the user header view (implemented as a custom view)
  - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- Home Timeline
  - [x] Tapping on a user image should bring up that user's profile page
  - [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
- [x] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Optional: Retweeting and favoriting should increment the retweet and favorite count.
- [x] Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. Refer to this guide for help on implementing unretweeting.
- [x] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [ ] Optional: Pulling down the profile page should blur and resize the header image.
- [ ] Optional: Account switching
  - Optional: Long press on tab bar to bring up Account view with animation
  - Optional: Tap account to switch to
  - Optional: Include a plus button to add an Account
  - Optional: Swipe to delete an account

## Questions

- The TweetView and TweetTableViewCell shares most functionalities, how to reuse code between the too?
- Better way than `self.edgesForExtendedLayout = .None;` when dealing with the navigation bar covering content?
- There are multiple places that could trigger the user view, how is the navigation handled usually? (e.g. on web there is a centralized router through URL)
- What's the best way to pass things into a VC? (through a method? Directly setting the properties? Through init?)

## License

    Copyright 2016 Chengyin Liu

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
