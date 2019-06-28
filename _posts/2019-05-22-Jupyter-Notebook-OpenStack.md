---
layout: post
title: "Jupyter on OpenStack"
description: "Jupyter Notebook configuration on OpenStack-hosted server"
category: articles
tags: [Jupyter Notebook, OpenStack, Apache, config]
comments: false
---

Creating an instance of a virtual machine on OpenStack that will host Jupyter Notebook server proxied trough an Apache server.

# How to setup Jupyter Notebook server on OpenStack

This tutorial will guide you trough configuration of an externally-accessible (trough Internet) Jupyter Notebook server.

Steps:
1. [Setup instance and network on OpenStack](#setup-instance-and-network-on-openstack)
2. [Configure SSH connection](#configure-ssh-connection)
3. [SSL certificate](#ssl-certificate)
4. [Install and configure Apache server](#install-and-configure-apache-server)
5. [Install and configure Jupyter Notebook server](#install-and-configure-jupyter-notebook-server)


## Setup instance and network on OpenStack

Remember to open port 443 on your OpenStack Instance, then `Soft Reboot` the instance


## Configure SSH connection

Remember to open port 443 on your OpenStack Instance, then `Soft Reboot` the instance


## SSL Certificate

In order to generate a self-signed certificate type in the following commands ((source for `openssl` key generation))[https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#using-ssl-for-encrypted-communication]:
```bash
mkdir ~/.certs
cd ~/.certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykey.key -out mycert.pem
```

## Install and configure Apache server

This step is required in order to proxy your server (no need of running Jupyter Notebook as root).

Make sure that self-signed certificates were generated (see previous step).

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

__Note:__ Both: apache and Jupyter notebook have to have SSL certificates set, and it have to be the same certificates.

Enable site and restart the server
```bash
sudo a2ensite jupyter.conf
sudo service apache2 restart
```


## Install and configure Jupyter Notebook server

Jupyter has to be run on a non-sudo user. Hence, create a new user, e.g.:
```bash
sudo adduser aeneas
```
Note: do not append this user to sudoers group.

Create password and hash it ([source](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#preparing-a-hashed-password)):
```python
In [1]: from notebook.auth import passwd
In [2]: passwd()
```

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

In order to debug the notebook, running on port 80 as root, use the following config:
```python
c.NotebookApp.allow_origin = '*'
c.NotebookApp.allow_remote_access = True
c.NotebookApp.base_url = '/jupyter'
c.NotebookApp.certfile = '/etc/certs/mycert.pem'
c.NotebookApp.keyfile = '/etc/certs/mykey.key'
c.NotebookApp.ip = 'localhost'
c.NotebookApp.open_browser = False
c.NotebookApp.password = u'sha1:9696<some_password>'
c.NotebookApp.trust_xheaders = True
```

***

### Sources

 * [Official documentation](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#using-lets-encrypt)
 * [Jupyter and Apache](https://www.linode.com/docs/applications/big-data/install-a-jupyter-notebook-server-on-a-linode-behind-an-apache-reverse-proxy/)
 * [Working Apache configuration](https://stackoverflow.com/a/28819231/8877692)
 * [Generate password with Ipython](https://github.com/paderijk/jupyter-password/blob/master/jupyter-password.py)

***

Last modified on 28 June 2019
