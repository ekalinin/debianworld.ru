layout: post
title: Установка и настройка Django, Nginx через Tornado в Debian / Ubuntu
date: 2010-03-10
tags:
- debian
-  ubuntu
-  nginx
-  tornado
-  python
-  git
-  django
categories: articles
permalink: ustanovka-i-nastrojka-django-nginx-cherez-tornado-v-debian-ubuntu
---
**Tornado (торнадо)** - это неблокирующий, высоко производительный веб-сервер с открытыми исходным кодом. Авторами сервера являются создатели сервиса FriendFeed. Сервер реализован средствами языка Python и в силу своей неблокирующей природы (используется **epoll**) легко выдерживает тысячи одновременных подключений. Помимо всего прочего, [Tornado поддерживает](http://www.tornadoweb.org/documentation#wsgi-and-google-appengine "Поддержка WSGI в сервере Tornado") протокол [WSGI](http://ru.wikipedia.org/wiki/WSGI "Что такое WSGI?"), хотя и с небольшими ограничениями (будут не доступны асинхронные фичи сервера). 

Учитывая все это, можно предположить, что возможность запуска Django с помощью Tornado может стать достойной альтернативой описанному ранее способу запуска [Django через FastCGI](http://debianworld.ru/articles/ustanovka-i-nastrojka-django-nginx-cherez-fastcgi-flup-v-debian-ubuntu/ "Запуск Django с помощью nginx, fastcgi и flup"). Итак, проверим...
<!-- more -->
Механизм взаимодействия будет классическим:

  * **front-end** - nginx, проксирующий все соединения, кроме статических файлов, на back-end
  * **back-end** - tornado + django

Установка nginx
-------------------
В первую очередь необходимо установить fron-end, коим будет являться весьма популярный http-сервер nginx. Установка проста:

``` bash
    $ sudo aptitude install nginx
```
Установка django
---------------------
Далее, необходимо установить фреймворк Django. Эта процедура [уже не раз описывалась](http://debianworld.ru/articles/ustanovka-i-nastrojka-django-nginx-cherez-fastcgi-flup-v-debian-ubuntu/ "Запуск Django с помощью nginx, fastcgi и flup") в [предыдущих статьях, посвященных Django](http://debianworld.ru/articles/ustanovka-i-nastrojka-apache-mod_wsgi-django-mysql-v-debian-ubuntu/ "Установка и настройка Apache, mod_wsgi, Django"). Так что ограничимся лишь кодом установки без комментариев.

Получение исходный код фреймворка:

``` bash
    $ mkdir ~/django
    $ cd ~/django
    $ wget http://www.djangoproject.com/download/1.1.1/tarball/
    $ tar xzf Django-1.1.1.tar.gz
```
Установка Django:

``` bash
    $ python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"
    /usr/lib/python2.5/site-packages
    $ sudo ln -s ~/django/Django-1.1.1/django /usr/lib/python2.5/site-packages/django
    $ sudo ln -s ~/django/Django-1.1.1/django/bin/django-admin.py /usr/local/bin
    $ python -c "import django; print django.VERSION;"
    (1, 1, 1, 'final', 0)
```
Установка tornado
----------------------
К сожалению, tornado все еще отсутствует в стандартных репозиториях Debian / Ubuntu. Поэтому процесс установки будет выполняться непосредственно из исходных кодов. Подготовка к получению исходных кодов и компиляции:

``` bash
    # устанавливаем git, чтобы скачать исходный код tornado
    $ sudo aptitude install git-core gitosis
    # устанавливаем пакет необходимый для сборки в Debian / Ubuntu
    $ sudo aptitude install python-dev build-essential
```
После этого необходимо получить исходный код tornado:

``` bash
    $ cd ~ && git clone git://github.com/facebook/tornado.git
```
И наконец, выполнить установку tornado:

``` bash
    $ cd ~/tornado && sudo python setup.py install
```
Проверяем корректность установки:

``` bash
    $ python -c "import tornado; print 'tornado installation successfully completed';"
    tornado installation successfully completed
```
Настройка wsgi
-------------------
Чтобы заставить работать Django-код под Tornado, необходимо написать wsgi-прослойку, запускающую tornado-сервер на определенном порту и подключающую django-проект по протоколу wsgi. Код должен выглядеть приблизительно так:

``` python
    #!/usr/bin/env python
    # -*- coding: utf-8 -*-
    # location: deploy/tornading.py
    
    import os
    import sys
    
    # настройки
    DJANGO_ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    DJANGO_APPS_DIR = os.path.join(DJANGO_ROOT_DIR, 'apps')
    
    def daemon(iport):
        import tornado.wsgi
        import tornado.ioloop
        import tornado.httpserver
    
        # настраиваем django
        sys.path.insert(0, DJANGO_APPS_DIR)
        os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
        import django.core.handlers.wsgi
        application = django.core.handlers.wsgi.WSGIHandler()
    
        # подключаем tornado
        container = tornado.wsgi.WSGIContainer(application)
        http_server = tornado.httpserver.HTTPServer(container)
        http_server.listen(iport)
        tornado.ioloop.IOLoop.instance().start()
    
    if __name__ == "__main__":
        # на вход должен быть передан порт, 
        # на котором будет запущен tornado-сервер
        daemon(int(sys.argv[1]))
    
```
При этом предполагается, что код проекта распределен следующим образом:

``` bash
    $ tree -d  -L 1
    .               # корень django-проекта
    |-- apps        # django-приложения
    |-- cache
    |-- deploy
    |-- logs
    |-- media
    `-- templates   # django-шаблоны
```
Процесс создания аналогичной структуры проекта подробно описан в статье [Запуск Django с помощью nginx, fastcgi и flup](http://debianworld.ru/articles/ustanovka-i-nastrojka-django-nginx-cherez-fastcgi-flup-v-debian-ubuntu/ "Запуск Django с помощью nginx, fastcgi и flup")

Настройка nginx
-------------------
После того, как tornado-сервер запущен, можно переходить к настройке nginx:

``` bash
    $ sudo vim /etc/nginx/sites-available/debianworld.ru
```
Файл конфигурации должен выглядеть приблизительно следующим образом:

``` apache
    upstream backends {
        server 127.0.0.1:8001;
        server 127.0.0.1:8002;
    }
```
    server {
        listen   80;
        server_name tornado.debianworld.ru;

        access_log /home/django-projects/debianworld_ru/logs/nginx_access.log;
        error_log /home/django-projects/debianworld_ru/logs/nginx_error.log;

        location = /robots.txt {
            alias /home/django-projects/debianworld_ru/media/robots.txt;
        }

        location = /favicon.ico {
            alias /home/django-projects/debianworld_ru/media/img/favicon.ico;
        }

        location /media/ {
            alias /home/django-projects/debianworld_ru/media/;
            expires 30d;
        }

        location /media_admin/ {
            alias /usr/lib/python2.6/dist-packages/django/contrib/admin/media/;
            expires 30d;
        }

        location / {
            proxy_pass http://backends;
            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }

Далее, необходимо включить хост:

``` bash
    $ sudo ln -s /etc/nginx/sites-available/debianworld.ru \
             /etc/nginx/sites-enabled/debianworld.ru
```
Чтобы новый хост заработал, необходимо перестартовать nginx:

``` bash
    $ sudo /etc/init.d/nginx restart
```
Запуск демона tornado
----------------------------
Для запуска Django-проекта осталось лишь запустить tornado-сервер на нужном порту с помощью wsgi-прослойки, написанной ранее:

``` bash
    $ python deploy/tornading.py 8001 &
    $ python deploy/tornading.py 8002 &
```
Все. Django-проект запущен под nginx+tornado. 

Для того, чтобы убедиться, что все настроено правильно, необходимо открыть в браузере url: "http://tornado.debianworld.ru" (или тот, который прописан в Вашем виртуальном хосте nginx) и убедиться в наличии надписи:

    It worked!
    Congratulations on your first Django-powered page.

Остается лишь написать скрипт для автозапуска tornado-серверов и мониторинга их работоспособности. Но об этом в - одной из следующих статей.