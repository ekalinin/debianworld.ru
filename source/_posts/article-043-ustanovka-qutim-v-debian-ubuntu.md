layout: post
title: Установка qutIM в Debian / Ubuntu
date: 2009-09-09
tags:
- ubuntu
-  qutim
-  debian
-  instant-messaging
-  icq
-  jabber
-  irc
categories: articles
permalink: ustanovka-qutim-v-debian-ubuntu
---
**qutIM** - новый многопротокольный (**ICQ**, **Jabber**/GTalk, Ya.Online, LiveJournal.com/, **Mail.Ru**, **IRC**,  **В контакте**) клиент для обмена мгновенными сообщениями. Основной язык реализации - C++,  библиотека - Qt 4.3, что обеспечивает кроссплатформенность клиента. **qutIM** предоставляет интерфейс для расширения функциональности через плагины, в частности, так реализованы все поддерживаемые протоколы. **qutIM** бесплатен и распространяется в исходных кодах.

Основные возможности:

  * X-статусы
  * Поддержка плагинов
<!-- more -->
  * Использование вкладок в окнах сообщений
  * Спам-фильтр
  * Приватные списки
  * Одновременная работа нескольких учётных записей
  * Поддержка нескольких протоколов
  * Многоязычный интерфейс
  * Передача файлов
  * Поддержка HTTP- и SOCKS 5-proxy
  * Поддержка аватаров
  * Поддержка статусных иконок от Adium и смайлов
  * Поддержка стилей окна чата от Adium
  * Поддержка звуков
  * Отчёт о доставке сообщения
  * Уведомления о наборе текста

Установка qutIM
===========
Перед началом установки необходимо прописать пути к репозитариям:

Для **Ubuntu Karmic Koala 9.10**:

``` bash
    $ sudo su
    $ echo "deb deb http://qutim.org/debian/karmic karmic main" >> /etc/apt/sources.list
    $ echo "deb-src http://qutim.org/debian/karmic karmic main" >> /etc/apt/sources.list
```
Для **Ubuntu Jaunty 9.04**:

``` bash
    $ sudo su
    $ echo "deb http://qutim.org/debian/jaunty jaunty main" >> /etc/apt/sources.list
    $ echo "deb-src http://qutim.org/debian/jaunty jaunty main" >> /etc/apt/sources.list
```
Для **Debian Lenny 5.0** / stable:

``` bash
    $ sudo su
    $ echo "deb http://qutim.org/debian/lenny lenny main" >> /etc/apt/sources.list
    $ echo "deb-src http://qutim.org/debian/lenny lenny main" >> /etc/apt/sources.list
```
Для **Debian Squeeze 6.0** / testing:

``` bash
    $ sudo su
    $ echo "deb http://qutim.org/debian/squeeze squeeze main" >> /etc/apt/sources.list
    $ echo "deb-src http://qutim.org/debian/squeeze squeeze main" >> /etc/apt/sources.list
```
Следующим шагом необходимо добавить GPG ключ:

``` bash
    $ wget -O - http://qutim.org/debian/archive.key | sudo apt-key add -
    $ sudo aptitude update
```
При этом станут доступны следующие пакеты:

``` bash
    $ aptitude search qutim
    p   qutim                            - lightweight, fast and friendly Instant Messenger
    p   qutim-dbg                        - qutIM debug symbols
    p   qutim-dev                        - qutIM plugin development headers
    p   qutim-languages                  - qutIM language pack
    p   qutim-plugin-floaties            - qutIM floating contacts
    p   qutim-plugin-floaties-dbg        - qutIM Floaties debug symbols
    p   qutim-plugin-kde-integration     - KDE integration metapackage set
    p   qutim-plugin-kdecrash            - KDE crash plugin for qutIM
    p   qutim-plugin-kdeemoticons        - KDE emoticons plugin for qutIM
    p   qutim-plugin-kdenotification     - KDE Notification plugin for qutIM
    p   qutim-plugin-kdephonon           - Phonon plugin for qutIM
    p   qutim-plugin-kdespeller          - KDE speller plugin for qutIM
    p   qutim-plugin-nowlistening        - qutIM Now Listening plugin
    p   qutim-plugin-nowlistening-dbg    - qutIM plugin manager debug symbols
    p   qutim-plugin-plugman             - qutIM plugin manager
    p   qutim-plugin-plugman-dbg         - qutIM plugin manager debug symbols
    p   qutim-protocol-icq               - qutIM ICQ protocol support
    p   qutim-protocol-icq-dbg           - qutIM ICQ protocol debug symbols
    p   qutim-protocol-irc               - qutIM IRC protocol support
    p   qutim-protocol-irc-dbg           - qutIM IRC protocol debug symbols
    p   qutim-protocol-jabber            - qutIM Jabber protocol support
    p   qutim-protocol-jabber-dbg        - qutIM Jabber protocol debug symbols
    p   qutim-protocol-jabber-dev        - qutim Jabber protocol development headers
    p   qutim-protocol-mrim              - qutIM MRIM protocol support
    p   qutim-protocol-mrim-dbg          - qutIM MRIM protocol debug symbols
```
И самое простое - это **установка qutim**:

    ##bash##
    $ sudo aptitude install qutim