layout: post
title: Установка и настройка Django, Nginx через FastCGI (flup) в Debian / Ubuntu
date: 2009-11-11
tags:
- ubuntu
-  debian
-  django
-  nginx
-  flup
-  fastcgi
-  python
categories: articles
permalink: ustanovka-i-nastrojka-django-nginx-cherez-fastcgi-flup-v-debian-ubuntu
---
 **Django** (**Джанго**) - это динамично развивающийся web фреймворк с открытым исходным кодом, реализованный на языке **Python**. Рекомендуемым способом установки Django является связка Apache + mod_wsgi. Как это делается уже рассказывалось ранее в статье ["Установка и настройка Apache, mod_wsgi, Django, MySQL"](http://debianworld.ru/articles/ustanovka-i-nastrojka-apache-mod_wsgi-django-mysql-v-debian-ubuntu/ "Пример установки Django на Apache, mod_wsgi. А так же пример подключения MySQL к проекту на Django"). 

Однако, всем известно, насколько Apache может быть "тяжелым" для сервера, особенно для статического контента. Поэтому, если нет желания, ставить связку Apache+Nginx, для проектов на Django можно обойтись только одним сервером Nginx. Запуск можно выполнять через FastCGI.
<!-- more -->

Установка Django, Nginx, Flup
==========================

Установка последней стабильной версии Django
----------------------------------------------------------
Для установки последней версии необходимо скачать исходники и распаковать их:

``` bash
    $ mkdir ~/django
    $ cd ~/django
    $ wget http://www.djangoproject.com/download/1.1.1/tarball/
    $ tar xzf Django-1.1.1.tar.gz
```
Далее, необходимо узнать, в какую директорию необходимо устанавливать пакеты, чтобы Python узнал об этом. Для этого необходимо выполнить:

``` bash
    $ python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"
    /usr/lib/python2.5/site-packages
```
В данном случае, видно что основной версией является Python 2.5 и все дополнительные пакеты устанавливаются в директорию "/usr/lib/python2.5/site-packages". 

Следующим шагом необходимо создать символическую связь для распакованной директории Django:

``` bash
    $ sudo ln -s ~/django/Django-1.1.1/django /usr/lib/python2.5/site-packages/django
```
И в конце, чтобы сделать команду django-admin.py доступной из любой директории системы, необходимо добавить еще одну символическую ссылку:

``` bash
    $ sudo ln -s ~/django/Django-1.1.1/django/bin/django-admin.py /usr/local/bin
```
Чтобы убедиться, что Django нормально установлен, необходимо запустить интерпретатор Python и импортировать модуль django:

``` bash
    $ python -c "import django; print django.VERSION;"
    (1, 1, 1, 'final', 0)
```
Все в порядке. Последняя версия Django корректно установлена.

Установка Nginx, flup
--------------------------
Чтобы  иметь возможность запускать Django через FastCGI необходимо установить пакет flup, который представляет из себя python-библиотеку для работы с FastCGI. Итак, ставим nginx, flup:

``` bash
    $ sudo aptitude install nginx python-flup
```
Создание и настройка проекта в Django
=====================================
Первым делом создается сам Django-проект, после чего в него добавляются некоторые вспомогательные директории:

``` bash
    # директория для django проектов
    $ sudo mkdir -p /home/django-projects/debianworld_ru
```
    # новый django-проект
    $ cd /home/django-projects/debianworld_ru
    $ sudo django-admin.py startproject apps

    # директория для статики
    $ sudo mkdir -p /home/django-projects/debianworld_ru/media

    # директория для логов
    $ sudo mkdir -p /home/django-projects/debianworld_ru/logs

Корректировка настроек проекта
----------------------------------
Для того, чтобы django-проект корректно запустился, необходимо сделать несколько изменений в настройках:

``` bash
    # корректируем путь к модулю настроек url
    $ sudo perl -pi -e "s/apps.urls/urls/g" /home/django-projects/debianworld_ru/apps/settings.py
```
    # укзываем путь к статике для админики (см. конфиг nginx далее)
    $ sudo perl -pi -e "s/ADMIN_MEDIA_PREFIX = '\/media\/'/ADMIN_MEDIA_PREFIX = '\/media_admin\/'/g" \
                       /home/django-projects/debianworld_ru/apps/settings.py

    # для корректной работы fact-cgi необходимо обнулить FORCE_SCRIPT_NAME
    $ echo "FORCE_SCRIPT_NAME = ''" | sudo tee -a /home/django-projects/debianworld_ru/apps/settings.py


Создание пользователя для проекта
----------------------------------
Для того, чтобы изолировать код проекта от остальной системы, необходимо добавить в систему пользователя, от имени которого будет исполняться код проекта:

``` bash
    # создается системная группа
    $ sudo addgroup --quiet --system dw
```
    # создается системный пользователь
    $ sudo adduser --quiet --system --ingroup dw --no-create-home --no-create-home dw

Расстановка прав на директории
------------------------------
Необходимо, чтобы доступ к исходному коду имел только владелец, но при этом надо обеспечить взаимодействие с web-сервером через сокет (см. далее), а так же дать доступ к статическим файлам пользователю веб сервера. Для этого, необходимо выполнить следующее:

``` bash
    # Установка нового владельца проекта. Группа пользователя http-сервера (www-data)
    # добавлена для того, чтобы  обеспечить доступ к некоторым директориям для сервера
    $ sudo chown dw:www-data -R /home/django-projects/debianworld_ru
```
    # Установка прав доступа на проект. Чтение/запись есть только у владельца.
    # http-серверу (www-data) позволяем только читать
    $ sudo chmod u=rwx,g=rx,o= -R /home/django-projects/debianworld_ru

    # Доступ к исходному django-коду должен быть только у владельца
    $ sudo chmod u=rwx,g=,o= -R /home/django-projects/debianworld_ru/apps

    # В данной директории будт находиться не только логи веб-сервера, 
    # но и сокет. Поэтому необходимо обеспечить:
    # 	* автоматическое создание сокета с группой http-сервера
    # 	* возможность записи в сокет от имени пользователя http-сервера
    # Для этого необходимо сделать:
    #   * выставить бит sgid, чтобы файлы создавались с тойже группой, что и у директории logs
    #   * выставить доступ на запись для пользователя http-сервера
    $ sudo chmod u=rwx,g=rwxs,o= -R /home/django-projects/debianworld_ru/logs


Настройка и запуск Django под Nginx через FastCGI
=================================================
Взаимодействие Nginx и Django будет проиходить через сокет. Для этого необходимо настроить Nginx для передачи входящих запросов демону FastCGI, и не забыть запустить сам FastCGI демон.
FastCGI - демон, в случае Django, запускается почти как простой девелоперский Django-сервер, за исключением нескольких новых параметров.

Кроме сокета, возможен вариант взаимодействия между Nginx и Django через http, но он проще в настройке чем вариант с сокетами, и как правило используется в ситуациях, когда сервера разнесены по разным машинам.

В данном же случае, оба сервера находятся на одной машине, поэтому эффективнее использовать сокет.

Настройка виртуального хоста в Nginx
-------------------------------------
Первым делом, необходимо убедиться, что есть конфигурационный файл для передачи FastCGI параметров. Файл /etc/nginx/fastcgi_params должен иметь следующий вид:

``` apache
    fastcgi_param  QUERY_STRING       $query_string;
    fastcgi_param  REQUEST_METHOD     $request_method;
    fastcgi_param  CONTENT_TYPE       $content_type;
    fastcgi_param  CONTENT_LENGTH     $content_length;
```
    fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
    fastcgi_param  REQUEST_URI        $request_uri;
    fastcgi_param  DOCUMENT_URI       $document_uri;
    fastcgi_param  DOCUMENT_ROOT      $document_root;
    fastcgi_param  SERVER_PROTOCOL    $server_protocol;

    fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
    fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

    fastcgi_param  REMOTE_ADDR        $remote_addr;
    fastcgi_param  REMOTE_PORT        $remote_port;
    fastcgi_param  SERVER_ADDR        $server_addr;
    fastcgi_param  SERVER_PORT        $server_port;
    fastcgi_param  SERVER_NAME        $server_name;

    # PHP only, required if PHP was built with --enable-force-cgi-redirect
    fastcgi_param  REDIRECT_STATUS    200;

Далее, следует добавить файл настройки виртуального хоста:

``` bash
    $ sudo vim /etc/nginx/sites-available/fastcgi.debianworld.ru
```
И добавить следующий текст:

``` apache
    server {
        listen      80;
        server_name fastcgi.debianworld.ru;
        access_log  /home/django-projects/debianworld_ru/logs/nginx_access.log;
        error_log   /home/django-projects/debianworld_ru/logs/nginx_error.log;
	
        # связь с fastcgi сервером
        location / {
            fastcgi_pass    unix:/home/django-projects/debianworld_ru/logs/django-server.sock;
            include         fastcgi_params;
```
            fastcgi_param              PATH_INFO        $fastcgi_script_name;
            fastcgi_pass_header        Authorization;
            fastcgi_intercept_errors   off;
        }
    
        # статическое содержимое проекта
        location /media/ {
            alias /home/django-projects/debianworld_ru/media/;
            expires 30d;
        }

        # статическое содержимое админки    
        location /media_admin/ {
            alias /usr/lib/python2.5/site-packages/django/contrib/admin/media/;
            expires 30d;
        }
    }


Далее, необходимо включить хост:

``` bash
    $ sudo ln -s /etc/nginx/sites-available/fastcgi.debianworld.ru \
                 /etc/nginx/sites-enabled/fastcgi.debianworld.ru
```
Чтобы новый хост заработал, необходимо перестартовать nginx:

``` bash
    $ sudo /etc/init.d/nginx restart
```
Запуск Django FastCGI сервера
------------------------------
Так как в рассматриваемом случае Django и Nginx стоят на одной машине, то логичнее при запуске использовать сокет.

Сервер запускается следующей коммандой:

``` bash
    # запуск сервера fastcgi
    $ sudo -u dw python /home/django-projects/debianworld_ru/apps/manage.py \
		  runfcgi method=prefork \
		  maxchildren=10 maxspare=5 minspare=2 maxrequests=100 \
		  socket=/home/django-projects/debianworld_ru/logs/django-server.sock \
		  pidfile=/home/django-projects/debianworld_ru/logs/django-server.pid \
		  umask=007
```
Все параметры при запуске очевидны. Необходимо лишь отметить "umask=007" выставляется он для того, чтобы право на работу с сокетом имели только владелец и группа сокета. 
В данном случае, это, соответственно, пользователь dw и группа www-data.

Останов Django FastCGI сервера
------------------------------
Сервер останавливается следующей коммандой:

``` bash
    $ sudo -u dw kill `sudo -u dw cat /home/django-projects/debianworld_ru/logs/django-server.pid`
```

Проверка правильности настройки
===============================
Для того, чтобы убедиться, что все настроено правильно, необходимо открыть в браузере url: "http://fastcgi.debianworld.ru" (или тот, который прописан в Вашем виртуальном хосте nginx) и убедиться в наличии надписи:

    It worked!
    Congratulations on your first Django-powered page.

