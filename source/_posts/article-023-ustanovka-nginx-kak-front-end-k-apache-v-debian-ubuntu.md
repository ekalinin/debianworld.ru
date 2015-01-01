layout: post
title: Установка nginx как frontend к apache в Debian / Ubuntu
date: 2009-06-15
tags:
- apache
- nginx
- debian
- ubuntu
- web-сервер
categories: articles
permalink: ustanovka-nginx-kak-front-end-k-apache-v-debian-ubuntu

---

Рано или поздно перед администратором встает задача разгрузить **backend**, которым как правило, является **apache**. Одной из альтернатив для **frontend** является легкий web сервер **Nginx**. Данная конфигурация дает особенно большой выигрыш при наличии подключений по медленным каналам связи (модем), так как ресурсы системы начинают использоваться для дела, а не ждать, пока будет получен запрос или отдан ответ клиенту.

<!-- more -->

Преимущества архитектуры frontend/backend
===========================================
В случае использования только **apache**, при наличии медленных подключений, последний бОльшую часть времени просто ждет, либо пока будет полностью получен запрос, либо пока будет полностью передан ответ клиенту. При этом под каждое соединение будет выделено определенное количество памяти, и, как не трудно догадаться, общее количество одновременных подключений будет прямо пропорционально доступному объему памяти.

В случае же **frontend/backend конфигурации** ситуация немного иная:  **frontend** ( в нашем случае, **nginx**) полностью обрабатывает входящий запрос, используя при этом минимум системных ресурсов. Передает запрос  **backend**'у (**apache**), быстро получает ответ и начинает передачу ответа клиенту. Таким образом, ресурсы, занятые под **apache**, были использованы только для того, чтобы сгенерировать запрошенный контент, и были сразу возвращены системе после завершения работы. А с клиентом общается лишь легкий и не требовательный к ресурсам **frontend nginx**.

Общий вид схемы frontend/backend
==================================
В общем виде, http-соединение будет проделывать следующий путь:

    HTTP Client  ---->  FrontEnd (nginx)   ---->  BackEnd (apache)
    -----------  <----  -----------------  <----  -----------------
    1.2.3.4:80          192.168.0.1:80            192.168.0.1:8080

В данном случае, fronend и backend располагаются на одной машине. В общем же случае, при необходимости они могут работать на разных машинах.

Установка и настройка Nginx
===========================

Установка Nginx
---------------
Установка Nginx тривиальна, начиная с Lenny (5.0). До этого, чтобы поставить nginx версии 0.6 и выше, необходимо было собирать пакет вручную.

``` bash
    $ sudo aptitude install nginx
```
Запускаем nginx:

``` bash
    $ sudo /etc/init.d/nginx start
```
Набираем в браузере: "http://192.168.0.1" (IP той машины, где был установлен nginx). Должно появиться приглашение nginx: "Welcome to nginx!".

Настройка проксирования в Nginx
-------------------------------
Отключаем сайт по умолчанию:

``` bash
    $ sudo rm /etc/nginx/sites-enabled/default
```
Корректируем конфигурационный файл:

``` bash
    $ sudo vim /etc/nginx/nginx.conf
```
Должен иметь приблизительно следующий вид:

``` apache
    # пользователь, от которого запускается процесс
    user www-data;
    # кол-во рабочих процессов. Обычно равно кол-ву ядер на машине
    worker_processes  2;

    error_log  /var/log/nginx/error.log;
    pid        /var/run/nginx.pid;

    events {
        worker_connections  1024;
    }

    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        access_log  /var/log/nginx/access.log;

        sendfile        on;
        tcp_nopush     on;

        keepalive_timeout  2;
        tcp_nodelay        on;

        gzip  on;
        gzip_comp_level 3;
        gzip_proxied any;
        gzip_types text/plain text/html text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript;

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
    }
```
Останавливаем nginx:

``` bash
    $ sudo /etc/init.d/nginx stop
```
Создаем файл конфигурации proxy.conf:

``` bash
    $ sudo vim /etc/nginx/proxy.conf
```
Должен иметь следующий вид:

``` apache
    proxy_redirect              off;
    proxy_set_header            Host $host;
    proxy_set_header            X-Real-IP $remote_addr;
    proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;
    client_max_body_size        10m;
    client_body_buffer_size     128k;
    proxy_connect_timeout       90;
    proxy_send_timeout          90;
    proxy_read_timeout          90;
    proxy_buffer_size           4k;
    proxy_buffers               4 32k;
    proxy_busy_buffers_size     64k;
    proxy_temp_file_write_size  64k;
```
Настройка виртуального хоста в Nginx
------------------------------------
Создаем файл виртуального хоста:

``` bash
    $ sudo vim /etc/nginx/sites-available/debianworld.ru
```
Файл следующего вида:

``` apache
    upstream backend {
      # Адрес back-end'a
      server 192.168.0.1:8080;
    }

    server {
        listen   80;
        server_name www.debianworld.ru debianworld.ru;

        access_log /home/site/debianworld.ru/logs/nginx_access.log;
        error_log /home/site/debianworld.ru/logs/nginx_error.log;

        # Перенаправление на back-end
        location / {
            proxy_pass  http://backend;
            include     /etc/nginx/proxy.conf;
        }

        # Статическиое наполнение отдает сам nginx
        # back-end этим заниматься не должен
        location ~* \.(jpg|jpeg|gif|png|ico|css|bmp|swf|js)$ {
            root /home/site/debianworld.ru/static/;
        }
    }
```

Включаем новый хост:

``` bash
    $ sudo ln -s /etc/nginx/sites-available/debianworld.ru /etc/nginx/sites-enabled/debianworld.ru
```

Продолжение [тут](/articles/ustanovka-nginx-kak-front-end-k-apache-v-debian-ubuntu-2).
