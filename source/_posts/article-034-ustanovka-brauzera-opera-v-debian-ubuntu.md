layout: post
title: Установка браузера Opera в Debian / Ubuntu
date: 2009-07-03
tags:
- debian
-  opera
-  ubuntu
-  utils
-  браузер
categories: articles
permalink: ustanovka-brauzera-opera-v-debian-ubuntu
---
**Opera** - один из самых популярных браузеров. Отличается высокой скоростью работы. Распространяется только в бинарном виде (без исходных кодов), но его можно **скачать бесплатно с сайта opera**.
<!-- more -->
Подготовка к установке Opera
=====================
Подключаем новый apt-репозитарий:

``` bash
    $ sudo su
    $ echo "deb http://deb.opera.com/opera/ stable non-free" >> /etc/apt/sources.list
```
Обновляем список доступных пакетов:

``` bash
    $ sudo aptitude update
```
Следующим шагом необходимо добавить PGP-ключи для Opera. 
Вариант #1:

``` bash
    $ wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
```
Вариант #2:

``` bash
    $ gpg --keyserver subkeys.pgp.net --recv-key 6A423791
    $ gpg --fingerprint 6A423791
    $ gpg --armor --export 6A423791| apt-key add -
```
Установка Opera
===========
Для установки браузера необходимо выполнить:

``` bash
    $ sudo aptitude install opera
```
