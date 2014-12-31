layout: post
title: Установка nginx как front-end к apache в Debian / Ubuntu - 2
date: 2009-06-15
tags:
- apache
-  nginx
-  debian
-  ubuntu
-  web-сервер
categories: articles
permalink: ustanovka-nginx-kak-front-end-k-apache-v-debian-ubuntu-2
---
Установка и настройка Apache
====================
Установка Apache
---------------------
Установка проста:

``` bash
    $ sudo aptitude install apache2
```
Настройка Apache
---------------------
Корректируем конфигурационный файл:

``` bash
    $ sudo vim /etc/apache2/apache2.conf
```
Необходимо найти и скорректировать следующие строки (при отсутствии добавить):

``` apache
    # Таймаут 90 секунд
    Timeout 90
    
    # Выключаем KeepAlive
    KeepAlive Off
```
    # Имя сервера
    ServerName debianworld.ru

Перезагружаем apache:

``` bash
    $ sudo apache2ctl graceful
```
Проверяем корректную настройку apache, открываю в браузере: "http://192.168.0.1" (IP той машины, где был установлен apache). Должно появиться "It works!".

Отключаем хост по умолчанию:

``` bash
    $ sudo a2dissite 000-default
```
Настраиваем apache на работу с портом 8080, а не 80:

``` bash
    $ sudo vim /etc/apache2/ports.conf
```
Должен иметь вид:

``` apache
    NameVirtualHost *:8080
    Listen 8080
```
Перезагружаем apache, nginx:

``` bash
    $ sudo apache2ctl graceful
    $ sudo /etc/init.d/nginx start
```
Настройка mod_rpaf
-------------------------
Теперь, если посмотреть в логи apache, то там все запросы будут идти с адреса front-end'a. Чтобы это исправить, необходимо установить модуль mod_rpaf:

``` bash
    $ sudo aptitude install libapache2-mod-rpaf
```
И настроить его:

``` bash
    $ sudo vim /etc/apache2/mods-enabled/rpaf.conf
```
Должен выглядеть примерно так:

``` apache
    <IfModule mod_rpaf.c>
        # Включаем модуль
        RPAFenable On
```
        # Приводит в порядок X-Host
        RPAFsethostname On
 
        # Адрес фронтенда (nginx)       
        RPAFproxy_ips 127.0.0.1 192.168.0.1
    </IfModule>

Перезагружаем apache:

``` bash
    $ sudo /etc/init.d/apache2 force-reload
```
Настройка виртуального хоста в Apache
------------------------------------------------
Создаем файл виртуального хоста:

``` bash
    $ sudo vim /etc/apache2/sites-available/debianworld.ru
```
Приблизительно следующего содержания:

``` apache
    <VirtualHost *:8080>
        # Осн. настройки домена
        ServerAdmin admin@debianworld.ru
        ServerName www.debianworld.ru
        ServerAlias debianworld.ru
```
        <Directory /home/site/debianworld.ru/apache/>
            Order deny,allow
            Allow from all
        </Directory>

        LogLevel warn
        ErrorLog  /home/site/debianworld.ru/logs/apache_error.log
        CustomLog /home/site/debianworld.ru/logs/apache_access.log combined
        
       # Остальные настройки
       # ...
    </VirtualHost>

С описанием правил настройки виртуальных хостов для apache можно ознакомится, например, [тут](http://httpd.apache.org/docs/2.2/vhosts/ "Описание настройки виртуальных хостов для apache2")

Включаем новый хост:

    ##bash##
    $ sudo a2ensite <domain name>
    $ sudo /etc/init.d/apache2 reload
