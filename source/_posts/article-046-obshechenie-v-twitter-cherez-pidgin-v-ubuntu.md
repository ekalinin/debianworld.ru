layout: post
title: Общение в Twitter через Pidgin в Ubuntu
date: 2009-09-16
tags:
- ubuntu
- pidgin
- twitter
- instant-messaging
categories: articles
permalink: obshechenie-v-twitter-cherez-pidgin-v-ubuntu

---

**Twitter** - бесплатная система микроблогов (читается как **твиттер**), позволяющая пользователям отправлять короткие текстовые заметки (до 140 символов). Отправлять сообщения можно используя веб-интерфейс, SMS, службы мгновенных сообщений или сторонние программы-клиенты. 

Но с недавнего времени появилась возможность делать посты в twitter через популярный мессенджер pidgin, превратить его в полноценный **twitter клиент**. Новая функциональность появилась благодаря плагину **microblog-purple**.

<!-- more -->

Установка плагина для Twitter - microblog-purple
================================================
Первым делом необходимо добавить новые репозитории.

Для **Ubuntu Jaunty 9.04**:

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/sugree/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/sugree/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
```
Для **Ubuntu Intrepid 8.10**:

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/sugree/ppa/ubuntu intrepid main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/sugree/ppa/ubuntu intrepid main" >> /etc/apt/sources.list
```
Следующим шагом необходимо добавить GPG ключ:

``` bash
    $ sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0CF459B8DF37ED8B
    $ sudo aptitude update
```
И, наконец, сама установка плагина для Twitter в pidgin:

``` bash
    $ sudo aptitude install pidgin-microblog
```
