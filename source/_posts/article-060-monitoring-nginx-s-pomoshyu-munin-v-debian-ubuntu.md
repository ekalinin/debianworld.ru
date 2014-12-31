layout: post
title: Мониторинг nginx с помощью Munin в Debian / Ubuntu
date: 2010-02-28
tags:
- debian
-  ubuntu
-  nginx
-  munin
-  мониторинг
categories: articles
permalink: monitoring-nginx-s-pomoshyu-munin-v-debian-ubuntu
---
**Munin** - весьма удобное средство, чтобы выполнять **мониторинг серверов**. Идущие в составе пакета плагины, позволяют практически сразу настроить мониторинг памяти, процессора, свободного места и т.д. [Установка Munin уже описывалась ранее](http://debianworld.ru/articles/ustanovka-i-nastrojka-munin-v-debian-ubuntu/ "Установка Munin, настройка доступа через Nginx, Apache"), и касалась не только основного пакета, но и настройки доступа к статистике через один из популярных http-серверов: Apache или Nginx. Однако и для самих http-серверов, как правило, статистика так же лишней не бывает. И если для Apache у Munin уже есть идущие в составе пакета плагины (apache_accesses, apache_processes, apache_volume), то для Nginx таковых нет. Исправить ситуацию не сложно.
<!-- more -->
Установка Nginx и Munin
------------------------------
Установка nginx, munin выполняется просто:

``` bash
    $ sudo aptitude install nginx munin munin-node
```
Основные настройки Munin уже описывались [ранее](http://debianworld.ru/articles/ustanovka-i-nastrojka-munin-v-debian-ubuntu/ "Установка и настройка Munin в Debian / Ubuntu").

Настройка Nginx для вывода статуса сервера
--------------------------------------------------------
Для того, чтобы мониторинг nginx был возможен, необходимо добавить следующий location в конфигурацию сервера (файл  настройки дефолтного сервера/etc/nginx/sites-enabled/default):

``` apache
    http {
        #...
        server {
            listen localhost;
            #...
            location /nginx_status {
                stub_status on;
                access_log  off;
                allow       127.0.0.1;
                deny        all;
            }
            #...
        }
        #...
    }
```
Перезагружаем сервер:

``` bash
    $ sudo /etc/init.d/nginx restart
    Restarting nginx: nginx.
```
Проверяем работу:

``` bash
    $ telnet localhost 80
    Trying 127.0.0.1...
    Connected to localhost.
    Escape character is '^]'.
```
    # пишем
    GET /nginx_status

    # должны получить
    Active connections: X 
    server accepts handled requests
     X X X
    Reading: X Writing: X Waiting: X 

Все. Nginx готов, чтобы его мониторили.

Установка плагинов Munin для Nginx
---------------------------------------------
Следующим шагом, необходимо скачать плагины для мониторинга Nginx:

``` bash
    # переходим в каталог доступных плагинов munin
    $ cd /usr/share/munin/plugins
```
    # скачиваем плагины для nginx
    # мониторинг запросов
    $ sudo wget -O nginx_request http://muninexchange.projects.linpro.no/download.php?phid=64
    # мониторинг статуса сервера
    $ sudo wget -O nginx_status http://muninexchange.projects.linpro.no/download.php?phid=65
    # мониторинг занимаемой памяти
    $ sudo wget -O nginx_memory http://muninexchange.projects.linpro.no/download.php?phid=626 

Далее, необходимо включить установленные плагины:

``` bash
    # делаем плагины исполняемыми
    $ sudo chmod +x nginx_request
    $ sudo chmod +x nginx_status
    $ sudo chmod +x nginx_memory 
```
    # включаем плагины
    $ sudo ln -s /usr/share/munin/plugins/nginx_request /etc/munin/plugins/nginx_request
    $ sudo ln -s /usr/share/munin/plugins/nginx_status /etc/munin/plugins/nginx_status
    $ sudo ln -s /usr/share/munin/plugins/nginx_memory /etc/munin/plugins/nginx_memory

Далее, необходимо указать плагинам, куда ходить за статистикой Nginx. Для этого, необходимо вписать следующее:

``` bash
    $ echo "" | sudo tee -a /etc/munin/plugin-conf.d/munin-node
    $ echo "[nginx*]" | sudo tee -a /etc/munin/plugin-conf.d/munin-node
    $ echo "env.url http://localhost/nginx_status" | sudo tee -a /etc/munin/plugin-conf.d/munin-node
```
Проверяем работу плагинов:

``` bash
    $ sudo munin-run nginx_memory
    ram.value 1814528
```
    $ sudo munin-run nginx_request
    Name "main::port" used only once: possible typo at /etc/munin/plugins/nginx_request line 49.
    Can't locate object method "new" via package "LWP::UserAgent" at /etc/munin/plugins/nginx_request line 55.

Чтобы исправить ошибку, необходимо поставить пакет libwww-perl:
  
``` bash
    sudo aptitude install libwww-perl
```
Проверяем, что ошибка пропала:

``` bash
    $ sudo munin-run nginx_request
    Name "main::port" used only once: possible typo at /etc/munin/plugins/nginx_request line 49.
    request.value 3
```
Все хорошо. Плагины работают. Перезагружаем клиент Munin:

``` bash
    $ sudo /etc/init.d/munin-node restart
    Stopping Munin-Node: done.
    Starting Munin-Node: done.
```
Все. Можно констатировать, что мониторинг Nginx настроен. Остается лишь [настроить Nginx для просмотра графиков](http://debianworld.ru/articles/ustanovka-i-nastrojka-munin-v-debian-ubuntu-3/ "Настройка доступа к Munin через Nginx").