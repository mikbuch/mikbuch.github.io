---
layout: post
title: "Jupyter for Computational Neuroscience"
description: "This guide will walk you trough working with Jupyter Notebook environment (pipenv)"
category: articles
tags: [python, jupyter, pipenv, ipython notebook]
comments: false
---

The first step for creating usable notes and didactics materials is the proper
preperation of your tools. Hence, the basics of setting up the Jupyter Notebook
server in a python virtual environment with pipenv will be described here.

The content described here is platform-independent, however, linux is the
recommended environment for such activities. First, before creating Jupyter
environment we have to understand how it works on a ready example. I suggest
we use an example we will be working on later on: [https://github.com/mikbuch/compcog](https://github.com/mikbuch/compcog).

Clone the directory using atom or command line:
{% highlight bash %}
git clone https://github.com/mikbuch/compcog
{% endhighlight %}

I assume that you have Python and pipenv already installed on your system. If
that is not the case, install them now with repositories (Linux) or with an
installer (Windows):
[https://www.python.org/downloads/windows/](https://www.python.org/downloads/windows/).

Now open the terminal and type in:
{% highlight bash %}
pipenv shell
{% endhighlight %}

Once the pipenv finishes installing packages specified in a `Pipfile`, type
{% highlight bash %}
jupyter notebook
{% endhighlight %}
in the same terminal you run the virtual environment in. Now you are good to go.
