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
   ![01-Karabiner-complex-main](/images/Adapting-macOS/01-Karabiner-complex-main.png)
 3. Click `+ Add rule`
 4. `Import more rules from the Internet ...`
   ![02-Karabiner-complex-add-rule](/images/Adapting-macOS/02-Karabiner-complex-add-rule.png)
 5. On the web page that will be opened, find and import `Exchange command + arrow keys with option + arrow keys`
 6. You are done

`TODO` get home and end to work (for non-mac keyboard)

# Logitech K850 polish diacritics

For Logitech K850 keyboard on the right of the space key there is a command button. If you are used to having alt there (option) for typing polish characters, it may be distrurbing.
![03-Keyboard-Logitech-K850](/images/Adapting-macOS/03-Keyboard-Logitech-K850.png)
The way to fix that is to add `Simple Modification` in Karabiner:
`right_command` -> `right_option`
![04-Karabiner-Logitech-K850-right-Cmd-to-option](/images/Adapting-macOS/04-Karabiner-Logitech-K850-right-Cmd-to-option.png)

# Logitech K850 and Jupyter

It is disturbing (so far) only with this keyboard in Jupyter, but rightmost key on bottom right corner (just before arrows) is an `option` key by default. It should be the `control` key for easier running cells in Jupyter (run-without-creating-new-cell-below is more often required -- ctrl+return).

![05-Karabiner-Logitech-K850-right-option-to-ctrl](/images/Adapting-macOS/05-Karabiner-Logitech-K850-right-option-to-ctrl.png)

Additionally, to view in macOS which keys are being pressed go to keyboard settings from status bar, and then `Show Keyboard Viewer`:

![06-Show-Keyboard-Viewer](/images/Adapting-macOS/06-Show-Keyboard-Viewer.png)
![07-Keyboard-Viewer](/images/Adapting-macOS/07-Keyboard-Viewer.png)

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

Last modified on 23 August 2019
