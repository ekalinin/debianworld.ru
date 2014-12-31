layout: post
title: Установка Skype в Debian / Ubuntu x64 (64-bit)
date: 2009-09-14
tags:
- debian
-  instant-messaging
-  skype
-  ubuntu
-  x64
categories: articles
permalink: ustanovka-skype-v-debian-ubuntu-x64-64-bit
---
**Skype** (читается как **скайп**) - **бесплатный клиент** для общения в сети (включая возможность выполнять голосовые и видео звонки - **VoIP**). 

Для пользователей классических x86 систем установка этого клиента не занимает много времени и не доставляет никаких проблем. Но для пользователей x64-архитектур ситуация немного иная, так как x64-сборки не существует, соответственно, зачастую **установка Skype** сопровождается некоторым количеством трудностей. 
<!-- more -->
Установка x86 окружения
==================
В силу того, что будет устанавливаться x86 клиент, первым делом необходимо установить x86-окружение. Для этого необходимо выполнить:

``` bash
    $ aptitude install ia32-libs ia32-libs-gtk libasound2-plugins
```
Установка Skype
===========
Первым делом, необходимо **скачать skype** с официального сайта.

Скачивание Skype в Debian
---------------------------------

``` bash
    $ wget -O skype-install.deb http://www.skype.com/go/getskype-linux-beta-deb
```
Скачивание Skype в Ubuntu
----------------------------------
Для ubuntu доступны две версии пакета skype, 64-bit и 32-bit, но обе они завязаны на 32-bit библиотеки. Для того, чтобы установить 64-bit версию, необходимо выполнить:

``` bash
    $ wget -O skype-install.deb http://www.skype.com/go/getskype-linux-beta-ubuntu-64
```
Если 64-bit версия не заработает, то предлагается установить 32-bit, выполнив следующую команду:

``` bash
    $ wget -O skype-install.deb http://www.skype.com/go/getskype-linux-beta-ubuntu-32
```
Установка Skype
--------------------
Установка skype должна выполняться c опцией игнорирования архитектуры пакета:

``` bash
    $ dpkg -i --force-architecture skype-install.deb
```
Запуск Skype
=========
Для того, чтобы запустить Skype в x86-окружении, необходимо выполнить:

    ##bash##
    $ linux32 skype