layout: post
title: Установка и настройка сервера nginx с поддержкой PHP в Debian / Ubuntu
date: 2009-06-24
tags:
- debian
-  ubuntu
-  nginx
-  php
-  fastcgi
-  lighttpd
-  web-сервер
categories: articles
permalink: ustanovka-i-nastrojka-servera-nginx-s-podderzhkoj-php-v-debian-ubuntu
---
**Nginx** - высоко **производительный HTTP сервер**, распространяемый с вместе с исходными кодами. Nginx стал популярным благодаря своей стабильности, богатому набору возможностей, простой конфигурацией и небольшим потреблением системных ресурсов. 

Встроенной поддержки **PHP в nginx нет**, но есть возможность работы с **FastCGI**. Благодаря этому, а так же fastcgi демону **spawn-fcgi, идущего вместе с сервером lighttpd**, **PHP-сайты** могут вполне благополучно работать **под nginx**.
<!-- more -->
Установка и настройка PHP
==================
Установка PHP
-----------------
Установка PHP не отличается от установки какого-либо другого пакета в Debian / Ubuntu. Выполняем установку непосредственно PHP(5), а так же поддержку **FastCGI в PHP**:

``` bash
    $ sudo aptitude install php5 php5-cgi
```
Настройка PHP
-----------------
После установки PHP, необходимо сделать некоторые настройки: обеспечить поддержку правильных  **PATH_INFO/PATH_TRANSLATED в CGI**. Для этого необходимо отредактировать файл **/etc/php5/cgi/php.ini** следующим образом:

``` apache
    # ...
    cgi.fix_pathinfo = 1
    # ...
```
Установка lighttpd
============
PHP может работать с nginx через FastCGI. Отдельного fastcgi демона в Debian / Ubuntu нет. Поэтому будет использован spawn-fcgi, идущий вместе с http сервером lighttpd. Для этого необходимо установить сам lighttpd:

``` bash
    $ sudo aptitude install lighttpd
```
Так как основным **HTTP сервером** будет **nginx**, то необходимо остановить lighttpd и отключить его запуск при старте системы:

``` bash
    # останавливаем  lighttpd 
    $ sudo /etc/init.d/lighttpd stop
    Stopping web server: lighttpd.
```
    # удаляем из авто загрузки
    $ sudo update-rc.d -f lighttpd remove
     Removing any system startup links for /etc/init.d/lighttpd ...
       /etc/rc0.d/K20lighttpd
       /etc/rc1.d/K20lighttpd
       /etc/rc2.d/S20lighttpd
       /etc/rc3.d/S20lighttpd
       /etc/rc4.d/S20lighttpd
       /etc/rc5.d/S20lighttpd
       /etc/rc6.d/K20lighttpd

Установка и настройка nginx, FastCGI
=========================
Установка nginx
-------------------
Установка nginx обычна для Debian / Ubuntu:

``` bash
    $ sudo aptitude install nginx
```
Настройка и запуск FastCGI
----------------------------------
Из установленного http сервера lighttpd, будет необходим лишь один скрипт: **usr/bin/spawn-fcgi**, который может быть использован для запуска FastCGI процессов.

Для того, чтобы запустить PHP  FastCGI демон, слушающий 9000 порт на localhost'е, и работающие под пользователем и группой www-data, необходимо выполнить:

``` bash
    $ sudo /usr/bin/spawn-fcgi -a 127.0.0.1 -p 9000 \
                      -u www-data -g www-data \
                      -f /usr/bin/php5-cgi \
                      -P /var/run/fastcgi-php.pid
```
Очевидно, что нет никакого желания вводить данную команду вручную после каждого старта системы. Для того, чтобы указанный выше скрипт запускался при загрузке системы, необходимо отредактировать файл **/etc/rc.local**:

``` apache
    # ...
    # Добавить в конце файла, перед командой "exit 0"
    /usr/bin/spawn-fcgi -a 127.0.0.1 -p 9000 -u www-data -g www-data -f /usr/bin/php5-cgi -P /var/run/fastcgi-php.pid
    # ...
```
Настройка nginx
-------------------
Все настройки nginx находятся в файле **/etc/nginx/nginx.conf**. Отредактируем хост по умолчанию:

``` bash
    $ sudo vim /etc/nginx/sites-available/default
```
Внесем следующие изменения:

``` apache
    server {
        listen   80;
        server_name  localhost;
```
        access_log  /var/log/nginx/localhost.access.log;

        location / {
                root   /var/www/nginx-default;
                index  index.php index.html index.htm;
        }

        # ...

        # Передаем PHP скрипт FastCGI серверу,
        # который прослушивает 127.0.0.1:9000
        location ~ \.php$ {
                fastcgi_pass   127.0.0.1:9000;
                fastcgi_index  index.php;
                fastcgi_param  SCRIPT_FILENAME  /var/www/nginx-default$fastcgi_script_name;
                include        fastcgi_params;
        }
        # ...
    }

В начальной конфигурации дефолтного хоста, блок *location ~ \.php$* закомментирован. Необходимо раскомментировать его. При этом, необходимо обратиться внимание на строчку "includefastcgi_params", что есть ошибка. Необходимо вписать пробелы, как это указано выше.

После чего необходимо перезагрузить nginx:

``` bash
    $ sudo /etc/init.d/nginx restart
```
Далее, создаем проверочный php-скрипт:

``` bash
    $ sudo vim /var/www/nginx-default/info.php
```
И вносим следующим код:

``` php
    <?php
    phpinfo();
    ?>
```
Далее, обращаемся к созданной странице info.php. Допуская, что IP сервера 10.1.0.4, необходимо обратиться по адресу: *http://10.1.0.4/info.php*. В результате будет выведена информация о PHP и его окружении. Необходимо обратить внимание на строчку **Server API**. Если значение в данной строке - **CGI/FastCGI**, то можно констатировать, что **PHP под nginx успешно установлен**.