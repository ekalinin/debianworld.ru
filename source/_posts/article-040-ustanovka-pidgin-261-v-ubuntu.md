layout: post
title: Установка Pidgin 2.6.1 в Ubuntu
date: 2009-08-20
tags:
- ubuntu
-  pidgin
-  instant-messaging
-  icq
-  jabber
-  irc
categories: articles
permalink: ustanovka-pidgin-261-v-ubuntu
---
**Pidgin** (ранее известный, как **gaim**) - клиент мгновенного обмена сообщениями, поддерживающий парктически все популярные протоколы (** ICQ**, **Jabber (XMPP)**, ** IRC**, **MSN** и т.д.). **Pidgin** использует библиотеку GTK+, чтоб обспечивает его кроссплатформенность. Кроме этого, функциональность **pidgin** может расширяться за счет системы плагинов. 

Основные возможности:

  * Объединение нескольких контактов в один метаконтакт
  * Запись протокола событий
  * Поддержка вкладок
  * Работа с несколькими аккаунтами одновременно
  * Поддержка аватаров
  * Слежение за пользователями
  * Кроссплатформенность

Новые возможности **Pidgin 2.6**.x:

  * поддержка аудио и видео по протоколу Google Talk (XMPP)
  * поддержка тем в libpurple

<!-- more -->

Установка Pidgin
===========

Возможны, как минимум два варианта установки **Pidgin 2.6.1**:

  * установка отдельного пакета (через dpkg)
  * установка через пакетный менеджер apt

Первый подход отличается простотой установки, так как не надо править конфиги, и достаточно лишь скачать deb-пакет и установить его.

Второй подход немного сложнее, но он гарантирует, что все последующие версии Pidgin попадут в Вашу систему в автоматическом режиме.

Ручная установка Pidgin (отдельным пакетом)
-------------------------------------------------------
Вся установка заключается в двух шагах:

  * скачать deb-пакеты ( например, [отсюда](http://www.getdeb.net/app/pidgin "deb-пакеты для pidgin 2.6.*") )
  * установить пакеты следющим образом:

    ``` bash
        $ sudo dpkg -i pidgin_2.6.1-1~getdeb1_i386.deb \
                           libpurple0_2.6.1-1~getdeb1_i386.deb \
                           libpurple-bin_2.6.1-1~getdeb1_all.deb \
                           pidgin-data_2.6.1-1~getdeb1_all.deb
```

Пакетная установка Pidgin
-------------------------------
Первым дело, необходимо добавить адреса apt-репозиториев.

Для **Ubuntu Jaunty 9.04**:

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/pidgin-developers/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/pidgin-developers/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
```

Для **Ubuntu Intrepid 8.10**:

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/pidgin-developers/ppa/ubuntu intrepid main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/pidgin-developers/ppa/ubuntu intrepid main" >> /etc/apt/sources.list
```

Следующим шагом необходимо добавить GPG ключ:

``` bash
    $ sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 67265eb522bdd6b1c69e66ed7fb8bee0a1f196a8
    $ sudo aptitude update
```
И, наконец, **установка pidgin**:

    ##bash##
    $ sudo aptitude install pidgin