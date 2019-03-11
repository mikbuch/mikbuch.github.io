---
layout: post
title: "Zsh Antigen"
description: "About my discovery of this magnificent tool"
category: articles
tags: [zsh, antigen, oh-my-zsh, config]
comments: false
---

Today I was looking for a more efficient way of loading an oh-my-zsh theme -- _clean_ ([https://github.com/BrandonRoehl/zsh-clean](https://github.com/BrandonRoehl/zsh-clean)). Until now I had to download the theme and manually install it in appropriate directory. While reading _clean_'s README, I stumbled upon Zsh Antigen ([https://github.com/zsh-users/antigen](https://github.com/zsh-users/antigen)).

Antigen is actually at the higher level than the mighty _oh-my-zsh_ as it allows managing oh-my-zsh, it's plugins and themes. Moreover, the author's manifesto in README seems both justified and ambitious. Anyway, by following _antigen_'s setup instruction you may easily install is:

```bash
curl -L git.io/antigen > ~/antigen.zsh
```

Then setting up the zsh is as simple as putting few lines in your `~/.zshrc` file:

```bash
source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen bundle BrandonRoehl/zsh-clean


# Tell Antigen that you're done.
antigen apply
```

Pay particular attention to these two lines:

```bash
...

antigen use oh-my-zsh
...
antigen theme BrandonRoehl/zsh-clean
...
```

First one allows you to install _oh-my-zsh_, with second you can easily choose a theme.


Then you have to, of course, source your zsh:

```bash
source ~/.zshrc
```

Now you can enjoy easier theme selection and plugin control for zsh.

***
### Appendix A
Check out my .zshrc at this location: [https://gist.github.com/mikbuch/de96c3a65908f87288c102a0931fd43c](https://gist.github.com/mikbuch/de96c3a65908f87288c102a0931fd43c)

### Appendix B

The complete workflow for installing Zsh and Antigen bundles:
```bash
sudo apt install zsh
chsh -s $(which zsh)
zsh
cd
wget "https://gist.githubusercontent.com/mikbuch/de96c3a65908f87288c102a0931fd43c/raw/5f476d339d19ed965bcfeddfe77def2d2ef08b78/.zshrc"
source ~/.zshrc
```

***

Last modified on 11 Mar 2019
