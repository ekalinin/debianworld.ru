layout: post
title: Установка и настройка web сервера Cherokee с поддержкой MySql и PHP в Debian / Ubuntu
date: 2009-07-03
tags:
- cherokee
-  mysql
-  php
-  debian
-  ubuntu
-  web-сервер
categories: articles
permalink: ustanovka-i-nastrojka-web-servera-cherokee-s-podderzhkoj-mysql-i-php-v-debian-ubuntu
---
**Cherokee** - очень **быстрый веб вервер**. Отличается большой гибкостью и легкостью в настройке. Поддерживает большое число современных технологий: **FastCGI**, SCGI, PHP, CGI, **TLS и SSL шифрованные соединения**, **виртуальные хосты**, аутентификация, кодирование на лету, **балансировщик нагрузки (Load balancing)**, Apache-совместимые лог файлы и т.д.

**Cherokee** имеет в комплекте довольно удобный GUI - интерфейс для **настройки веб сервера**. [Согласно проведенным тестам](http://www.cherokee-project.com/benchmarks.html "Сравнение производительности веб серверов: cherokee, lighttpd, nginx"), **производительность сервера** на статическом контенте превышает показатели таких серверов, как lighttpd и nginx.
<!-- more -->
Установка MySQL
============
Для работы с Mysql необходимо установить следующие пакеты:

``` bash
    $ sudo aptitude install mysql-server-5.0 mysql-client
```
Установка PHP
==========
Чтобы иметь возможность писать **скрипты php**, необходимо установить следующие пакеты:

``` bash
    $ sudo aptitude install php5 php5-cgi
```
Чтобы иметь возможность выполнять **mysql запросы** из php-скриптов, необходимо установить следующий пакет:

``` bash
    $ sudo aptitude install php5-mysql
```
Установка web сервера Cherokee
======================

Установка текущей версии Cherokee
---------------------------------------------
Чтобы поставить текущую версию сервера, еобходимо установить следующий пакет:

``` bash
    $ sudo aptitude install cherokee
```

Установка последней версии Cherokee в Ubuntu
----------------------------------------------------------
Сначала необходимо добавить новый apt-репозитарий:

``` bash
    $ sudo su
    $ echo "deb http://ppa.launchpad.net/cherokee-webserver/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
    $ echo "deb-src http://ppa.launchpad.net/cherokee-webserver/ppa/ubuntu jaunty main" >> /etc/apt/sources.list
```
Далее, необходимо добавить в систему соответствующие PGP-ключи:

``` bash
    $ sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0×0ad0b667b67daa477f5ff89f51bb8e83eba7bd49
```
После чего, установить пакет сервера:

``` bash
    $ aptitude update
    $ sudo aptitude install cherokee
```
Запуск web сервера Cherokee
------------------------------------
Проверяем, запущен ли сервер:

``` bash
    $ ps aux | grep cherokee
    root      6204  0.0  0.1   1756   444 ?        S    13:23   0:00 /usr/sbin/cherokee-guardian
    www-data  6205  0.0  0.5  35556  1472 ?        Sl   13:23   0:01 /usr/sbin/cherokee
```
Если же ничего не найдено, значит сервер не запущен. Чтоб его стартовать, необходимо выполнить:

``` bash
    $ sudo /etc/init.d/cherokee start
```
Проверка работы web-сервера Cherokee
===========================
Чтобы убедиться,  что сервер корректно установлен, необходимо создать классическую php страницу, выводящую информацию о системе. 

``` bash
    $ sudo su
    $ echo "<?php echo phpinfo(); ?>" > /var/www/info.php
```
Далее, необходимо обратиться к этой страничке по HTTP. Например, если адрес сервера - 10.1.0.4, то полный адрес страницы будет: http://10.1.0.4/info.php

Настройка web-интерфейса для администрирования Cherokee
=========================================
Одной из отличительных особенностей сервера Cherokee является идущий в комплекте web-интерфейс для его администрирования. Естественно, классический текстовый файл конфигуарции так же присутствует и располагается в **/etc/cherokee/cherokee.conf**.

Чтобы сделать доступным web-интерфейс администрирования, необходимо выполнить:

``` bash
    $ sudo cherokee-admin
```
После чего, для администрирования можно обращаться по адресу http://127.0.0.1:9090. То есть, доступ будет только с локальной машины. Чтобы разрешить управлять сервером с любого адреса, необходимо выполнить:

    ##bash##
    $ sudo cherokee-admin -b
