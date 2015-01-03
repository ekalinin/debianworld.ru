layout: post
title: Установка Chromium (Google Chrome) в Ubuntu
date: 2009-06-29
tags:
- ubuntu
- chrome
- utils
- браузер
- ubuntu-jaunty
- ubuntu-intrepid
categories: articles
permalink: ustanovka-chromium-google-chrome-v-ubuntu

---

**Google Chrome** - веб браузер от компании Google, использующий движок **WebKit**. Отличительной особенностью является то, что каждая вкладка в браузере является отдельным процессом. Таким образом, если при обработке какой-либо закладки возникнет ошибка, то её можно будет закрыть без риска потерять все данные в браузере. Так же был сильно доработан движок JavaScript, что значительно повлияло на скорость работы. Новый **движок javaScript** открыт в исходных кодах в рамках проекта **V8**.

До недавнего времени **Chrome** был доступен только на Windows платформах. Но в начале июня 2009 года были выложены первые публичные сборки  **Google Chrome под Linux** в рамках проекта **Chromium**. В настоящее время эти сборки имеют статус Beta и предназначены в основном для тестирования.

<!-- more -->

Подготовка к установке Chrome
=============================
В первую очередь необходимо добавить новые apt-репозитарии.

Подготовка к установке Chrome в Ubuntu 9.04 (Jaunty)
----------------------------------------------------

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/chromium-daily/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/chromium-daily/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
```
Подготовка к установке Chrome в Ubuntu 8.10 (Intrepid)
------------------------------------------------------

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/chromium-daily/ppa/ubuntu intrepid main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/chromium-daily/ppa/ubuntu intrepid main" >> /etc/apt/sources.list
```
Установка ключей
----------------
Далее, необходимо установить соответствующие PGP ключи:

``` bash
    # установка ключей
    $ sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xfbef0d696de1c72ba5a835fe5a9bf3bb4e5e17b5
    Executing: gpg --ignore-time-conflict --no-options --no-default-keyring \
        --secret-keyring /etc/apt/secring.gpg --trustdb-name /etc/apt/trustdb.gpg \
        --keyring /etc/apt/trusted.gpg --recv-keys \
        --keyserver keyserver.ubuntu.com 0xfbef0d696de1c72ba5a835fe5a9bf3bb4e5e17b5
    gpg: запрашиваю ключ 4E5E17B5 с hkp сервера keyserver.ubuntu.com
    gpg: ключ 4E5E17B5: открытый ключ "Launchpad PPA for chromium-daily" импортирован
    gpg: не найдено абсолютно доверяемых ключей
    gpg: Всего обработано: 1
    gpg:               импортировано: 1  (RSA: 1)

    # обновление репозитария
    $ sudo aptitude update
```

Установка Google Chrome (Chromium)
==================================
И в заключении, остается лишь выполнить тривиальную команду установки:

``` bash
    $ sudo aptitude install chromium-browser
```
