layout: post
title: Установка и настройка Munin в Debian / Ubuntu — Настройка доступа через Apache, Nginx
date: 2009-05-24
tags:
- debian
- ubuntu
- debian-lenny
- munin
- мониторинг
categories: articles
permalink: ustanovka-i-nastrojka-munin-v-debian-ubuntu-3

---

Продолжаем тему, начатую в [Установка и настройка Munin в Debian / Ubuntu](/articles/ustanovka-i-nastrojka-munin-v-debian-ubuntu) и продолженную в [Установка и настройка Munin в Debian / Ubuntu — Настройка клиента, управление плагинами](/articles/ustanovka-i-nastrojka-munin-v-debian-ubuntu-2/)

<!-- more -->

Ограничение доступа к Munin
===========================

После того, как настроены клиент/сервер Munin, появляется необходимость просматривать результаты их деятельности - графики. Для этого нам понадобится HTTP-сервер.

Далее будет описано, как настроить HTTP-сервер (в нашем случае, Apache2 или Nginx) для просмотра **графиков мониторинга сервера**. Кроме  того, не надо забывать, что информация о состоянии сервера является далеко не публичной, следовательно, надо позаботиться об ограничении доступа.

Доступ к Munin через Apache
---------------------------

Открываем файл редактирование хоста по умолчанию:

``` bash
    $ sudo vim /etc/apache2/sites-enabled/000-default
```
И редактируем его, чтобы получилось приблизительно следующая картина:

``` apache
    <VirtualHost *:8080>
        # ...
        DocumentRoot /var/www/
        <Directory />
            Options FollowSymLinks
            AllowOverride None
        </Directory>
        <Directory /var/www/>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride None
            Order allow,deny
            allow from all
        </Directory>

        <Location /munin>
            AuthType Basic
            AuthName "Subversion Repository"
            AuthUserFile /etc/munin/.passwd

            Require valid-user
        </Location>

        # ...
    </VirtualHost>
```

И рестартуем apache2:

``` bash
    $ sudo /etc/init.d/apache2 restart
```
Доступ к Munin через Nginx
--------------------------

Открываем файл редактирование хоста по умолчанию:

``` bash
    $ sudo vim /etc/nginx/sites-enabled/default
```
И редактируем его, чтобы получилось приблизительно следующая картина:

``` apache
    server {
            listen   80;
            server_name  localhost;
            # ...
            location /munin {
                    alias   /var/www/munin;
                    autoindex on;
                    auth_basic "Munin data. Please login";
                    auth_basic_user_file /etc/munin/.passwd;
            }
    }
```
И рестартуем nginx:

``` bash
    $ sudo /etc/init.d/nginx restart
```
Создание файла паролей для доступа к Munin
------------------------------------------

Создаем файлик, где будут располагаться пользователи, для которых будет открыт доступ к графикам производительности:

``` bash
    $ sudo htpasswd -c /etc/munin/.passwd shorrty
```
Добавляем еще одного пользователя:

``` bash
    $ sudo htpasswd /etc/munin/.passwd kev
```

Теперь можно пробовать смотреть на графики мониторинга Munin по следующему адресу http://server.ip/munin/
