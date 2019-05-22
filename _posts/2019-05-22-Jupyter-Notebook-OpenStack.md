---
layout: post
title: "Jupyter on OpenStack"
description: "Jupyter Notebook configuration on OpenStack-hosted server"
category: articles
tags: [Jupyter Notebook, OpenStack, Apache, config]
comments: false
---

Creating an instance of a virtual machine on OpenStack that will host Jupyter Notebook server proxied trough Apache server.

# How to setup Jupyter Notebook server on OpenStack

This tutorial will guide you trough configuration of an externally-accessible (trough Internet) Jupyter Notebook server.

General steps:
1. Setup instance and network on OpenStack
2. Configure SSH connection
3. Install and configure apache server (for proxy)
4. Install and configure Jupyter Notebook server


## Setup instance and network on OpenStack

## Configure SSH connection

## Install and configure Apache server (for proxy)

Prepare the configuration file at `/etc/apache2/sites-available/jupyter.conf` with the following settings:
```apache
Listen 443
<VirtualHost *:443>

  ServerName localhost

  # configure SSL
  SSLEngine on
  SSLCertificateFile /home/aeneas/.certs/mycert.pem
  SSLCertificateKeyFile /home/aeneas/.certs/mykey.key

  SSLProxyEngine On
  SSLProxyVerify none
  SSLProxyCheckPeerCN off
  SSLProxyCheckPeerName off
  SSLProxyCheckPeerExpire off

  Redirect permanent / https://150.254.165.72/jupyter

  <Location /jupyter>
    # preserve Host header to avoid cross-origin problems
    ProxyPreserveHost on
    ProxyPass         https://localhost:8888/jupyter
    ProxyPassReverse  https://localhost:8888/jupyter
    ProxyPassReverseCookieDomain localhost <ip or name of your server>
    RequestHeader set Origin "https://localhost:8888"
  </Location>

  <Location /jupyter/api/kernels/>
	ProxyPass        wss://localhost:8888/jupyter/api/kernels/
	ProxyPassReverse wss://localhost:8888/jupyter/api/kernels/
  </Location>

  <Location /jupyter/terminals/websocket/>
	ProxyPass        wss://localhost:8888/jupyter/terminals/websocket/
	ProxyPassReverse wss://localhost:8888/jupyter/terminals/websocket/
  </Location>
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
```

## Install and configure Jupyter Notebook server

Jupyter has to be run on a non-sudo user. Hence, create a new user, e.g.:
```bash
sudo adduser aeneas
```
Note: do not append this user to sudoers group.

Create Jupyter Notebook configuration file at `~/.jupyter/jupyter_notebook_config.py`:
```bash
vim ~/.jupyter/jupyter_notebook_config.py
```

Paste in the following configuration
```python
c.NotebookApp.allow_origin = '*'
c.NotebookApp.allow_remote_access = True
c.NotebookApp.base_url = '/jupyter'
c.NotebookApp.certfile = '/home/aeneas/.certs/mycert.pem'
c.NotebookApp.keyfile = '/home/aeneas/.certs/mykey.key'
c.NotebookApp.ip = 'localhost'
c.NotebookApp.open_browser = False
c.NotebookApp.password = u'sha1:bcd259ccf...<your hashed password here>'
c.NotebookApp.trust_xheaders = True
```

***

### Sources

 * [Official documentation](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#using-lets-encrypt)
 * [Jupyter and Apache](https://www.linode.com/docs/applications/big-data/install-a-jupyter-notebook-server-on-a-linode-behind-an-apache-reverse-proxy/)
 * [Working Apache configuration](https://stackoverflow.com/a/28819231/8877692)
 * [Generate password with Ipython](https://github.com/paderijk/jupyter-password/blob/master/jupyter-password.py)

***

Last modified on 22 May 2019
