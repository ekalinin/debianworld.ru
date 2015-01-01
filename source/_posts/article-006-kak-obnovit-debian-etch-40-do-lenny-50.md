layout: post
title: Как обновить Debian Etch (4.0 ) до Lenny (5.0)
date: 2009-05-16
tags:
- debian-etch
- debian-lenny
- обновление
categories: articles
permalink: kak-obnovit-debian-etch-40-do-lenny-50

---

Некоторое время назад [стал доступным очередной релиз](http://debian.org/News/2009/20090214 "Новость о новом релизе Debian 5.0 Lenny")  **GNU/Linux Debian 5.0 Lenny**. И даже больше - [уже появилось первое обновление](http://debian.org/News/2009/20090411 "Новость о первом обновлении Debian 5.0 Lenny"). И для многих становится актуальной проблема **обновления с Debian 4.0 Etch на Debian 5.0 Lenny**.

<!-- more -->

Подготовка к обновлению Debian Etch (4.0)
=========================================

**Сделайте полный бэкап** вашей системы. Для решения этой задачи средств в изобилии. Основными из них являются: **tar**, **dd**, **dump** / **restore** и др.

Начало обновления Debian Etch (4.0)
===================================

Для начала необходимо сделать резервную копию списка источников пакетов:

``` bash
    $ sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
```
Заменяем все вхождения **Etch** на **Lenny**:

``` bash
    $ sudo su
    $ sed 's/etch/lenny/g' /etc/apt/sources.list > /etc/apt/sources.list.tmp && mv /etc/apt/sources.list.tmp /etc/apt/sources.list
```
Теперь файл /etc/apt/sources.list должен выглядеть приблизительно следующим образом:

    deb http://ftp.ru.debian.org/debian/ lenny main contrib non-free
    deb-src http://ftp.ru.debian.org/debian/ lenny main contrib non-free
    deb http://security.debian.org/ lenny/updates main contrib non-free

**Внимание**: если по каким-то причинам в файле /etc/apt/sources.list используется слово **stable**, а не **etch**, то система управления пакетами **apt** уже использует пакеты из **Debian Lenny** начиная с того момента, как вышел его стабильный релиз.
Рекомендуется использовать имена релизов (etch, lenny и т.д.) вместо их общих названий (stable, testing и т.д.). Таким образом, у Вас будет полный контроль над составом пакетов и над моментом, когда потребуется обновить Debian до очередного релиза.

Выполняем обновления Debian Etch (4.0) до Debian Lenny (5.0)
============================================================

После того, как скорректирован файл источников пакетов необходимо обновить списки источников в apt:

``` bash
    $ sudo aptitude update
```
Далее, первым делом необходимо обновить саму систему управления пакетами - apt:

``` bash
    $ sudo aptitude install apt dpkg aptitude
```
И, наконец, выполняем обновление системы:

``` bash
    $ sudo aptitude full-upgrade
```
**Внимание**: опция dist-upgrade была переименована в full-upgrade в версии aptitude, идущей в составе Debian 5.0 Lenny. Однако, опция dist-upgrade так же доступна и её можно использовать для обновления:

``` bash
    $ sudo apt-get dist-upgrade
```
Последняя команда займет некоторое время. Время зависит от састава пакетов, которые были установлены в системе (которые будет необходимо обновить) и скорости интеренет-соединения. После того, как обновление будет выполнено будет необходимо выполнить перезагрузку, чтобы начать работу с новым ядром 2.6.26, идущим в Debian 5.0 Lenny.
