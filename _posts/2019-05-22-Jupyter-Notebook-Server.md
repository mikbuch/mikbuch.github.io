---
layout: post
title: "Jupyter Notebook Server"
description: "How to setup Jupyter Notebook server"
category: articles
tags: [Jupyter Notebook, server, Apache, config]
comments: false
---

Creating an instance of a virtual machine on OpenStack that will host Jupyter Notebook server proxied trough an Apache server.

The content here is mostly based on the information from the [official Jupyter Notebook documentation](https://jupyter-notebook.readthedocs.io/en/stable/config_overview.html). However, here only the essential information are provided, i.e., what is needed to quickly setup you Notebook server.

# How to setup Jupyter Notebook server on OpenStack

This tutorial will guide you trough configuration of an externally-accessible (trough Internet) Jupyter Notebook server.

Steps:
1. [Setup instance and network your server hosting Jupyter Notebook](#setup-instance-and-network-on-server)
2. [Configure SSH connection](#configure-ssh-connection)
3. [Create a user](#create-a-user)
4. [SSL certificate](#ssl-certificate)
7. [Install and configure Apache server](#install-and-configure-apache-server)
6. [Install and configure Jupyter Notebook server](#install-and-configure-jupyter-notebook-server)


## Setup instance and network on server

Remember to open port 443 on your firewall.


## Configure SSH connection

Make sure that you have SSH connection and you know root password for your machine.


## Create a user

For security reasons, it's better to run a Juputer instance as a non-sudo user. Hence, you have to create one:
```bash
sudo useradd -m aeneas
sudo passwd aeneas
```
Note:
 * `-m` is required to create user home directory
 * to remove the user, use `userdel aeneas`

To make sure that the user was created, you can inspect `/etc/passwords` with:
```bash
cat /etc/passwd
```
or:
```bash
awk -F':' '{ print $1}' /etc/passwd
```
(See [this](https://www.cyberciti.biz/faq/linux-list-users-command/) nixCraft FAQ entry for more details.)

Note:
 * do not append this user to sudoers group.

Now, terminate SSH session and connect as non-sudo created user:
```
ssh aeneas@IP -i ~/.ssh/SOME_CERT.pem
```

Where:
 * IP is your server's ip, e.g., 123.123.123.123
 * SOME_CERT is a file with private SSH key


## SSL Certificate

In order to generate a self-signed certificate type in the following commands ([source for `openssl` key generation](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#using-ssl-for-encrypted-communication)):
```bash
mkdir ~/.certs
cd ~/.certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykey.key -out mycert.pem
```

## Install and configure Apache server

### Prerequisites

For this you need `sudo` rights, so reconnect as sudo user, e.g.:
```bash
ssh debian@IP -i ~/.ssh/SOME_CERT.pem
```

Where:
 * IP is your server's ip, e.g., 123.123.123.123
 * SOME_CERT is a file with private SSH key

### Install Apache

Install and enable modules required by Jupyter.

```bash
sudo apt-get install apache2
sudo a2enmod ssl
```

### Configure Apache

This step is required in order to proxy your server (so there would be no need of running Jupyter Notebook as root).

Make sure that self-signed certificates were generated (see previous step).

Prepare the configuration file at `/etc/apache2/sites-available/jupyter.conf` with the following settings:

__CAUTION!__ Replace SERVER_IP with your server's IP

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

  Redirect permanent / https://SERVER_IP/jupyter

  <Location /jupyter>
    # preserve Host header to avoid cross-origin problems
    ProxyPreserveHost on
    ProxyPass         https://localhost:8888/jupyter
    ProxyPassReverse  https://localhost:8888/jupyter
    ProxyPassReverseCookieDomain localhost SERVER_IP
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

You wish to use virtual environment. For that install `pipenv` with `pip`.
```bash
sudo pip install pipenv
```

Jupyter has to be run on a non-sudo user. Hence, now terminate SSH session as `sudo` user and reconnect as non-sudo created user:
```
ssh aeneas@IP -i ~/.ssh/SOME_CERT.pem
```

Where:
 * IP is your server's ip, e.g., 123.123.123.123
 * SOME_CERT is a file with private SSH key

Create Pipfile
```bash
vim ~/Pipfile
```

And paste the following content:
```python
[[source]]
name = "pypi"
url = "https://pypi.org/simple"
verify_ssl = true

[dev-packages]

[packages]
jupyter = "*"
pandas = "*"
matplotlib = "*"
scipy = "*"
ipdb = "*"
seaborn = "*"
sklearn = "*"
statsmodels = "*"
opencv-python = "*"
notebook = "*"
ipython="*"

[requires]
python_version = "3.7"
```

Create password and hash it ([source](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#preparing-a-hashed-password)):
```python
In [1]: from notebook.auth import passwd
In [2]: passwd()
```

Create Jupyter Notebook configuration file at `~/.jupyter/jupyter_notebook_config.py`:
```bash
mkdir ~/.jupyter
vim ~/.jupyter/jupyter_notebook_config.py
```

Paste in the following configuration:
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

### Run as a service

Create the file with service:
```bash
vim /etc/systemd/system/jupyter.service
```

Change `$USER` to your user, and `$VENV_ID` to virtual environment ID.

To get the virtual env directory:
```bash
ls ~/.local/share/virtualenvs/
```

The service:

```bash
[Unit]
Description=Jupyter Workplace

[Service]
Type=simple
PIDFile=/run/jupyter.pid
ExecStart=/home/$USER/.local/share/virtualenvs/$USER-$VENV_ID/bin/jupyter-notebook --config=/home/$USER/.jupyter/jupyter_notebook_config.py
User=$USER
Group=$USER
WorkingDirectory=/home/$USER
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Finally, start and enable the service:
```bash
sudo systemctl start jupyter.service
sudo systemctl enable jupyter.service
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
echo "export LC_ALL=C.UTF-8 export LANG=C.UTF-8" >> ~/.bashrc && source ~/.bashrc
```

### Debugging as root at port 80

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

Last modified on Mar 27, 2020
