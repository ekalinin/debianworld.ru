layout: post
title: Установка Firefox 3.5 / Firefox 3.6 (ежедневные сборки) в Ubuntu Jaunty/Intrepid/Hardy
date: 2009-10-16
tags:
- ubuntu
-  utils
-  браузер
-  firefox
categories: articles
permalink: ustanovka-firefox-35-firefox-36-ezhednevnye-sborki-v-ubuntu-jauntyintrepidhardy
---
**Mozilla Firefox** - свободно распространяемый и динамично развивающийся браузер. Одно из основных достоинств браузера Mozilla Firefox - гибкость и расширяемость. Чтобы иметь возможность работать с **последней версией firefox**, необходимо лишь выполнить ниже следующие инструкции.
<!-- more -->

Подключение репозитария
==================
Первым делом необходимо подключить репозиторий, в который выкладываются ежедневные сборки последних версий Firefox.

Для **Ubuntu 9.04 (Jaunty)**:

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/ubuntu-mozilla-daily/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/ubuntu-mozilla-daily/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
```
Для **Ubuntu 8.10 (Intrepid)**:

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/ubuntu-mozilla-daily/ppa/ubuntu intrepid main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/ubuntu-mozilla-daily/ppa/ubuntu intrepid main" >> /etc/apt/sources.list
```
Для **Ubuntu 8.04 (Hardy)**:

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/ubuntu-mozilla-daily/ppa/ubuntu hardy main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/ubuntu-mozilla-daily/ppa/ubuntu hardy main" >> /etc/apt/sources.list
```
После чего, необходимо добавить PPA GPG ключ:

``` bash
    $ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 247510BE
    Executing: gpg --ignore-time-conflict --no-options --no-default-keyring \
         --secret-keyring /etc/apt/secring.gpg --trustdb-name /etc/apt/trustdb.gpg \
         --keyring /etc/apt/trusted.gpg \
         --keyserver keyserver.ubuntu.com --recv-keys 247510BE
    gpg: запрашиваю ключ 247510BE с hkp сервера keyserver.ubuntu.com
    gpg: ключ 247510BE: открытый ключ "Launchpad PPA for Ubuntu Mozilla Daily Build Team" импортирован
    gpg: Всего обработано: 1
    gpg:               импортировано: 1  (RSA: 1)
```
И в заключении, необходимо обновить данные о пакетах:

``` bash
    $ sudo apt-get update
```
Установка Firfox
===========
Теперь можно ставить необходимую версию Firefox.

Установка Firefox 3.5
-------------------------
Чтобы установить Firefox 3.5 необходимо выполнить:

``` bash
    $ sudo aptitude install firefox-3.5
```
Установка Firefox 3.6
-------------------------
Чтобы установить Firefox 3.6 необходимо выполнить:

``` bash
    $ sudo aptitude install firefox-3.6
```
Обновление Firefox
------------------------
После того, как Mozilla Firefox необходимой версии установлен, периодически будет появляться необходимость в обновлении его сборки. Для этого необходимо выполнить:

    ##bash##
    $ sudo aptitude safe-upgrade
