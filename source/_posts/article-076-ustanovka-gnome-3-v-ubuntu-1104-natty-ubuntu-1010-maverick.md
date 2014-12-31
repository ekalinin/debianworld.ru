layout: post
title: Установка Gnome 3 в Ubuntu 11.04 (Natty) / Ubuntu 10.10 (Maverick)
date: 2011-04-28
tags:
- gnome-3
-  ubuntu
-  ubuntu-natty
-  ubuntu-maverick
categories: articles
permalink: ustanovka-gnome-3-v-ubuntu-1104-natty-ubuntu-1010-maverick
---
**Gnome 3** - это абсолютно новое современное окружение рабочего стола,
разрабатываемое с учетом последних тенденций и наработок в области
пользовательского интерфейса.

Первый релиз состоялся меньше месяца назад. И уже сейчас можно проверить
работу нового окружения в Ubuntu последних версий.

<!-- more -->

Так как данный вид установки носить экспериментальный характер, перед
обновлением рабочего стола крайне рекомендуется сделать резервную копию. 

Установка Gnome 3
------------------
Установка достаточно проста - достаточно подключить репозиторий и 
установить соответствующий пакет.

Для пользователей **ubuntu 11.04**:

``` bash
    $ sudo add-apt-repository ppa:gnome3-team/gnome3
    $ sudo apt-get update
    $ sudo apt-get dist-upgrade
    $ sudo apt-get install gnome-shell
```
Для пользователей **ubuntu 10.10**:

``` bash
    $ sudo add-apt-repository ppa:ubuntu-desktop/gnome3-builds
    $ sudo apt-get update
    $ sudo apt-get dist-upgrade
    $ sudo apt-get install gnome3-session
```
После завершения установки пакетов необходимо перезагрузиться и в GDM 
выбрать GNOME Session.

Could not update ICEauthority file /home/user/.ICEauthority 
-----------------------------------------------------------

У некоторых пользователей появляется данная проблема. При входе (после 
ввода логина и пароля) появляется сообщение:

    Could not update ICEauthority file /home/user/.ICEauthority 

После чего пользователя опять перекидывает на форму ввода логина / пароля.

Один из вариантов решения проблемы - поставить альтернативную легковесную
оболочку (например, LXDE). То есть, в GDM или непосредственно при получении
ошибки, необходимо перейти в консоль (ALT+CTRL+F1 или HOST+F1 в VirtualBox)
и выполнить:

``` bash
    $ sudo apt-get install lxde
```
После окончания установки необходимо перезагрузить машину, войти один раз 
в систему, после чего сделать logout и уже в GDM выбирать GNOME Session.

Удаление Gnome 3
-----------------

Если новая окружение не пришлось по вкусу, го можно всегда удалить:

    ##bash##
    $ sudo apt-get install ppa-purge
    $ sudo ppa-purge ppa:gnome3-team/gnome3
