layout: post
title: Обновление Debian Lenny (5.0) до Debian Squeeze (6.0)
date: 2011-02-10
tags:
- debian-lenny
-  debian-squeeze
-  обновление
categories: articles
permalink: obnovlenie-debian-lenny-50-do-debian-squeeze-60
---
Буквально недавно [Debian Squeeze 6.0 стал стабильным](http://debianworld.ru/news/debian-60-squeeze-stal-stabilnym/ "Новость о новом релизе Debian 6.0 Squeeze"). И, соответственно, для многих становится актуальной проблема обновления Debian 5.0 Lenny до Debian 6.0 Squeeze. 
<!-- more -->

Подготовка к обновлению до Debian Squeeze 6.0
=================================
В первую очередь необходимо сделать бэкап Вашей системы. Для решения этой задачи есть масса средств. Резервную копию необходимо сделать, как минимум, для следующих директорий:

  * /etc
  * /var/lib/dpkg
  * /var/lib/apt/extended_states 
  * вывод команды dpkg --get-selections "*"
  * если вы используете aptitude, то /var/lib/aptitude/pkgstates

Так же необходимо сделать резервную копию списка источников пакетов:

``` bash
    $ sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
```

Обновление Debian Lenny 5.0 до Debian Squeeze 6.0
===================================

В списке источников пакетов необходимо сделать замену всех вхождений **Lenny** на **Squeeze**:

``` bash
    $ sudo su
    $ sed "s/lenny/squeeze/g" /etc/apt/sources.list > /etc/apt/sources.list.tmp && mv /etc/apt/sources.list.tmp /etc/apt/sources.list  
```
или, если использовать редактор vim:

``` bash
    $ sudo vim /etc/apt/sources.list
    # :%s/lenny/squeeze/gi
  
```
После этого, файл должен выглядеть приблизительно так:

    deb http://ftp.ru.debian.org/debian/ squeeze main contrib non-free
    deb-src http://ftp.ru.debian.org/debian/ squeeze main contrib non-free

    deb http://security.debian.org/ squeeze/updates main contrib non-free
    deb-src http://security.debian.org/ squeeze/updates main contrib non-free


После того, как скорректирован файл источников пакетов, необходимо обновить списки источников в apt:


``` bash
    $ sudo apt update
```

Далее, необходимо обновить саму систему управления пакетами - apt / aptitude:

``` bash
    $ sudo apt install apt dpkg aptitude
```
И - непосредственно само обновление:

``` bash
    $ sudo apt dist-upgrade
```
И наконец, перезагрузка системы:

    ##bash##
    $ sudo reboot