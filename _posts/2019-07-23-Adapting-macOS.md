---
layout: post
title: "Adapting macOS"
description: "Making few changes to macOS for usability purposes"
category: articles
tags: [macOS, keybindings, Mac OS X, config]
comments: false
---

Making macOS more usable in terms of keyboard navigation.

# Cmd+arrows to jump word

By default Cmd+right/left arrow sends you to end/binning of the line. The default keybind for jumping only one word is option+arrows, which is completely unusable (it is easier to use cmd). How often do you jump to the end/beginning of the line, compared to jumping/marking words?

The way to change it is to:
 1. Install Karabiner-Elements for macOS, then
 2. Go to `Complex Modifications` tab
   ![2019-07-23-Adapting-macOS_01-Karabiner-complex-main](/images/2019-07-23-Adapting-macOS_01-Karabiner-complex-main.png)
 3. Click `+ Add rule`
 4. `Import more rules from the Internet ...`
   ![2019-07-23-Adapting-macOS_02-Karabiner-complex-add-rule](/images/2019-07-23-Adapting-macOS_02-Karabiner-complex-add-rule.png)
 5. On the web page that will be opened, find and import `Exchange command + arrow keys with option + arrow keys`
 6. You are done

`TODO` get home and end to work (for non-mac keyboard)

# Logitech K850 polish diacritics

For Logitech K850 keyboard on the right of the space key there is a command button. If you are used to having alt there (option) for typing polish characters, it may be distrurbing.
![2019-07-23-Adapting-macOS_03-Keyboard-Logitech-K850](/images/2019-07-23-Adapting-macOS_03-Keyboard-Logitech-K850.png)
The way to fix that is to add `Simple Modification` in Karabiner:
`right_command` -> `right_option`
![2019-07-23-Adapting-macOS_04-Karabiner-Logitech-K850](/images/2019-07-23-Adapting-macOS_04-Karabiner-Logitech-K850.png)

# Homebrew (brew) for multiple users

Instructions ([source](https://medium.com/@leifhanack/homebrew-multi-user-setup-e10cb5849d59)):
 1. Add `brew` group, add users to this group, validate with:
 ```bash
 groups $USER
 ```
 2. Change group of Homebrew directory
 ```bash
 sudo chgrp -R brew /usr/local/Homebrew
 ```
 3. Allow group to write inside of Homebrew directory
 ```bash
 sudo chmod -R g+w /usr/local/Homebrew
 ```
 4. Check if you can use Homebrew:
 ```bash
 brew doctor
 ```

***

Last modified on 25 July 2019
