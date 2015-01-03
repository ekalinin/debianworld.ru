layout: post
title: Обновление сервера Ubuntu 8.10 (Intrepid) до Ubuntu 9.04 (Jaunty)
date: 2009-07-01
tags:
- ubuntu
- ubuntu-intrepid
- ubuntu-jaunty
- обновление
categories: articles
permalink: oblenie-servera-ubuntu-810-intrepid-do-ubuntu-904-jaunty

---

23 апреля состоялся релиз **Ubuntu 9.04 Server Edition**. Спустя некоторое время, можно плавно начинать **обновление серверов с  Ubuntu 8.10 (Intrepid) до Ubuntu 9.04 (Jaunty)**.

<!-- more -->

Подготовка к обновлению Ubuntu 8.10 (Intrepid)
==============================================
В первую очередь необходимо **сделать полный бэкап** системы. Для решения этой задачи средств в изобилии. Основными из них являются: **tar**, **dd**, **dump** / **restore** и др.

Обновления Ubuntu 8.10 (Intrepid) до Ubuntu 9.04 (Jaunty)
=========================================================
Для начала необходимо актуализировать версии пакетов:

``` bash
    $ sudo aptitude update
```
Далее, необходимо установить пакет для обновления релизов:

``` bash
    $ sudo aptitude install update-manager-core
```
Следующим шагом необходимо отредактировать файл **/etc/update-manager/release-upgrades**:

``` bash
    $ sudo vim /etc/update-manager/release-upgrades
```
И выставить:

``` apache
    # ...
    Prompt=normal
    # ...
```
Заключительным шагом будет запуск обновления пакетов:

``` bash
    $ sudo do-release-upgrade
```
Остается лишь следовать указаниям на экране.
