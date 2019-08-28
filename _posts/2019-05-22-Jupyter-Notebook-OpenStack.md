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

## Troubleshooting

### pipenv's ASCII vs. UTF-8

Circumstances:
 * basic system's Python version is 2.7
 * virtual env uses Python 3 (e.g. 3.5)
 * When trying to run `pipenv shell` command to go into venv's shell the following error is thrown:

```bash
aeneas@machine-gsr:~$ pipenv shell
Traceback (most recent call last):
  File "/usr/local/bin/pipenv", line 10, in <module>
    sys.exit(cli())
  File "/usr/local/lib/python3.5/dist-packages/pipenv/vendor/click/core.py", line 764, in __call__
    return self.main(*args, **kwargs)
  File "/usr/local/lib/python3.5/dist-packages/pipenv/vendor/click/core.py", line 696, in main
    _verify_python3_env()
  File "/usr/local/lib/python3.5/dist-packages/pipenv/vendor/click/_unicodefun.py", line 124, in _verify_python3_env
    ' mitigation steps.' + extra
RuntimeError: Click will abort further execution because Python 3 was configured to use ASCII as encoding for the environment. Consult https://click.palletsprojects.com/en/7.x/python3/ for mitigation steps.

This system supports the C.UTF-8 locale which is recommended.
You might be able to resolve your issue by exporting the
following environment variables:

    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8

Click discovered that you exported a UTF-8 locale
but the locale system could not pick up from it because
it does not exist.  The exported locale is "en_US.UTF-8" but it
is not supported
```

Solution:
Indeed, appending exports to ~/.bashrc fixes the issue:
```bash
echo "export LC_ALL=C.UTF-8
export LANG=C.UTF-8" >> ~/.bashrc && source ~/.bashrc
```

### Sources

 * [Official documentation](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#using-lets-encrypt)
 * [Jupyter and Apache](https://www.linode.com/docs/applications/big-data/install-a-jupyter-notebook-server-on-a-linode-behind-an-apache-reverse-proxy/)
 * [Working Apache configuration](https://stackoverflow.com/a/28819231/8877692)
 * [Generate password with Ipython](https://github.com/paderijk/jupyter-password/blob/master/jupyter-password.py)

***

Last modified on 28 June 2019
