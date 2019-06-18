---
layout: post
title: "JupyterHub on OpenStack"
description: "Jupyter Hub configuration on OpenStack-hosted server"
category: articles
tags: [JupyterHub, OpenStack, Apache, config]
comments: false
---

Creating an instance of a virtual machine on OpenStack that will host JupyterHub server proxied trough an Apache server.

# How to setup JupyterHub server on OpenStack

The general tutorial on how to install JupyterHub is available (here)(https://jupyterhub.readthedocs.io/en/stable/quickstart.html).

The combined commands are available (here)[https://gist.github.com/mikbuch/26c152c118caaa79ba13839f05cf8954], or in sections below.

Standard system upgrade:
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

Nodejs installation on debian (source (here)[https://tecadmin.net/install-laatest-nodejs-npm-on-debian/]):
```bash
sudo apt-get install curl software-properties-common
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install -y nodejs nodejs-legacy
```

Installing the Jupyter itself:
```bash
sudo apt-get install -y python3-pip
sudo python3 -m pip install jupyterhub
sudo npm install -g configurable-http-proxy
sudo python3 -m pip install notebook
```

To test the installation run:
```bash
jupyterhub -h
configurable-http-proxy -h
```

However, this tutorial is not meant for production environment, as JupyterHub requires special privileges in order to work:

> _To allow multiple users to sign in to the Hub server, you must start jupyterhub as a privileged user, such as root_

Hence, you are redirected to the separate (wiki page)[https://github.com/jupyterhub/jupyterhub/wiki/Using-sudo-to-run-JupyterHub-without-root-privileges], where it is explained how to run JupyterHub as a _less privileged user_.

Some additional resources in order to pull this of are:
1. Creating a user with home directory (from (here)[https://askubuntu.com/a/393470]):
```bash
sudo useradd -m cicero
sudo useradd -m demosthenes
```
2. Preventing other users from inspecting data in the specific user directory (explained (here)[https://superuser.com/a/161196/950943]):
```bash
sudo chmod go-rwx /home/cicero
sudo chmod go-rwx /home/demosthenes
```

Generate passwords for users:
```bash
sudo passwd cicero
sudo passwd demosthenes
```

Add users to `jupyterhub` group
```bash
sudo addgroup jupyterhub
sudo adduser -G jupyterhub cicero
sudo adduser -G jupyterhub demosthenes
```

Install `sudospawner`:
```bash
sudo python3 -m pip install sudospawner
```

Use `visudo` to edit `/etc/sudoers`. You should have his in your `sudoers` file:
```bash
# Cmnd alias specification

# the command(s) the Hub can run on behalf of the above users without needing a password
# the exact path may differ, depending on how sudospawner was installed
Cmnd_Alias JUPYTER_CMD = /usr/local/bin/sudospawner

# User privilege specification
root    ALL=(ALL:ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
%jupyterhub ALL=(cicero) /usr/bin/sudo
cicero ALL=(%jupyterhub) NOPASSWD:JUPYTER_CMD
```

Add user to shadow groups:
```bash
sudo usermod -a -G shadow cicero
```

Make a Directory for JupyterHub
```bash
sudo mkdir /etc/jupyterhub
sudo chown cicero /etc/jupyterhub
```

Install apache:
```bash
sudo apt-get install apache2
a2enmod ssl rewrite proxy proxy_http proxy_wstunnel
sudo systemctl restart apache2
```

In order to generate a self-signed certificate type in the following commands ((source for `openssl` key generation))[https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#using-ssl-for-encrypted-communication]:
```bash
mkdir ~/.certs
cd ~/.certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykey.key -out mycert.pem
```

Enable site and restart the server
```bash
sudo a2ensite jupyter.conf
sudo service apache2 restart
```

***

Last modified on 18 June 2019
