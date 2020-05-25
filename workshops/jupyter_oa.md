---
layout: default
title: Jupyter OA
---

# <a name="jupyter_oa"></a>Jupyter Notebook and server utilities[¶](#jupyter_oa)
<sup>January 21, 2020</sup>
&nbsp;

Workshop on Jupyter Notebook for Python and various server tools and utilities.

## Agenda

1. [Jupyter Notebook -- general overview](#1-jupter-notebook)
2. [Install and run Jupyter Notebook locally](#2-install-and-run-jupyter-notebook-locally)
3. [How to setup and run Jupyter instance on a server](#3-how-to-setup-and-run-jupyter-instance-on-a-server)
4. [Server tools](#4-server-tools):
    * [ZSH](#zsh)
    * [vim](#vim)
    * [tmux](#tmux)
    * [iTerm (for macOS)](#iterm-for-macos)
5. [IDEs](#5-ides)
    * [Atom (with plugins)](#atom-with-plugins)
    * [IntelliJ products, e.g., PyCharm](#intellij-products-eg-pycharm)
6. [Access over SSH, and SSL certificates](#6-access-over-ssh-and-ssl-certificates)

***

## Introduction

Who am I?
  * PhD student in Faculty of Psychology and Cognitive Science
  * Computer System Analyst in Poznan Supercomputing and Networking Center

Inspiration for this workshop

## 1. Jupter Notebook

![jupyter](/images/jupyter.png)

### Background
  * Growing interest in "user-friendly", high-performance technologies:
    * [Why Is Python So Popular?](https://academy.vertabelo.com/blog/why-is-python-so-popular/)
    * [Why Jupyter is data scientists’ computational notebook of choice](https://www.nature.com/articles/d41586-018-07196-1)
  * Deep Learning Workshops by nvidia ([certificate](https://drive.google.com/file/d/1e9Tc0INWAevvCUDOcJ_kPPc24qrlC3ak/view?usp=sharing))
  * It is fun :)

Basic example:
  * [Notebook basics](https://github.com/jupyter/notebook/blob/master/docs/source/examples/Notebook/Notebook%20Basics.ipynb)
  * [Running code, GitHub](https://github.com/jupyter/notebook/blob/master/docs/source/examples/Notebook/Running%20Code.ipynb)

Utils, part 1:
  * [nbviewer](https://nbviewer.jupyter.org/) -- render static Notebooks online; an example:
    * [Running code, nbviewer](https://nbviewer.jupyter.org/github/jupyter/notebook/blob/master/docs/source/examples/Notebook/Running%20Code.ipynb)

### Materials
  * [astro-python](https://github.com/christopherlovell/astro-python/tree/master/Notebooks)
  * [pandas-astro-example](https://github.com/zonca/pandas-astro-example)
  * [yt-project](https://yt-project.org/doc/quickstart/index.html) -- [visualising cosmology dataset](https://yt-project.org/doc/quickstart/simple_visualization.html)
  * [Astro Interactives](https://juancab.github.io/AstroInteractives/)
  * [Teaching materials example](http://www.usm.uni-muenchen.de/people/paech/Astro_Num_Lab/) -- [in nbviewer](https://nbviewer.jupyter.org/urls/owncloud.physik.uni-muenchen.de/index.php/s/UvAjga3BHTFxNYl/download)
  * [more, non-astro examples](https://github.com/mikbuch/hci/blob/master/01_02%20Jupyter%20Notebook.ipynb)
    
Utils, part 2:
  * [JupyterLab](https://jupyterlab.readthedocs.io/en/stable/) -- advanced, Matlab-like UI
  * [JupyterHub](https://jupyter.org/hub) -- multi-user, resources management

## 2. Install and run Jupyter Notebook locally

How to install and run Jupyter on various platforms -- [readthedocs](https://jupyter.readthedocs.io/en/latest/install.html).

TL;DR:
```bash
pip install jupyter notebook
jupyter notebook
```

## 3. How to setup and run Jupyter instance on a server

In order to run Jupyter Notebook on a server, it's best you knew the following concepts:
  * SSH
  * HTTPS access with (a self signed) SSL certificate
  * Apache HTTP(S) Server and how to configure it
  * Linux services (and autostart with systemd)

Do-it-yourself version is provided with these two web pages:
   * [Official Jupyter Notebook documentation](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html)
   * [My blog post on how to run Jupyter on OpenStack](http://mikbuch.github.io/articles/2019/05/22/Jupyter-Notebook-OpenStack.html)

## 4. Server tools:

### ZSH

![z-shell](/images/z-shell.png)

[General information](https://github.com/bilelmoussaoui/flatpak-zsh-completion/blob/master/README.md)

In short, `zsh` is a more interactive version of `bash`. What does the _interactive_ stand for? Basically, with `zsh` your `Tab` key becomes an intelligent, powerful entity (advanced autocompletion).

Particularly useful with:
  * typos
  * git
  * docker
  * and any other multi-argument bash utilities

Time for a little demonstration :)

Recommended `zsh` framework: [oh-my-zsh](https://ohmyz.sh/).

The easiest way to install `zsh`:

(with curl)
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

(with wget)
```bash
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

### vim

![vi-tariser](/images/vi-tariser.jpg)

tarsier /ˈtɑːsɪə/

[vim web page](https://www.vim.org/) tells you all

Descendant of `ex` line editor (reminiscence in `vi`'s _ex mode_).

Advantages:

  * you can macro \*anything\*
  * available on all server (on older distros as `vi`)
  * (supposedly :) ) speeds up some file-editing operations

Disadvantages:

![one-does-not-simply](/images/one-does-not-simply.jpeg)

### tmux

![tmux-vim](/images/tmux-vim.gif)

Terminal multiplexer -- your best friend both: locally and on a server.

[Nice introductory tutorial](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) on tmux.

Do you know [terminator](https://terminator-gtk3.readthedocs.io/en/latest/)? Tmux is similar, but better.

gpakosz has the best [tmux configuration](https://github.com/gpakosz/.tmux)

### iTerm (for macOS)

Next-gen terminal for macOS ([web page](https://www.iterm2.com/features.html)). I dont even remember the name of the default macOS terminal anymore...

![iterm-jump-to-file](/images/iterm-jump-to-file.gif)

## 5. IDEs

### Atom (with plugins)

[Atom](https://ide.atom.io/) is light, Atom is nice, Atom is open.

![atom-logo](/images/atom-logo.png)

Bare-bones Atom is very crude. However, there are plethora of plugins (aka packages)!

Must-have plugins:
  * [PlatformIO IDE Terminal](https://atom.io/packages/platformio-ide-terminal)
  * [Sync Settings](https://atom.io/packages/sync-settings)
  * [vim-mode-plus](https://atom.io/packages/vim-mode-plus)
  * [File icons](https://atom.io/packages/file-icons)

### IntelliJ products, e.g., PyCharm

![pycharm-example](/images/pycharm-example.png)

Magnificent, heavy, feature-packed:
  * build-in terminal support
  * decent git-management utilities (however, atom still has some advantages in that manner)
  * [free pro version](https://www.jetbrains.com/student/) for educational purposes

## 6. Access over SSH, and SSL certificates

SSH:
  * public vs. private key
  * password-based vs. certificate-based
  * command line vs. PuTTY
  

***

Last modified on Jan 20, 2020
