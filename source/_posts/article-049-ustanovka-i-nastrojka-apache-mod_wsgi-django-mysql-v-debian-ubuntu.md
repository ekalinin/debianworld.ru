layout: post
title: Установка и настройка Apache, mod_wsgi, Django, MySQL в Debian / Ubuntu
date: 2009-10-09
tags:
- debian
- ubuntu
- apache
- mod_wsgi
- django
- mysql
- python
categories: articles
permalink: ustanovka-i-nastrojka-apache-mod_wsgi-django-mysql-v-debian-ubuntu

---

**Django** (читается как **Джанго**) - это свободно распространяемый фреймворк с открытым исходным кодом для разработки веб приложений на языке **Python**. **Django** обладает следующими архитектурными отличиями:

  * использование концепции Модель-Представление-Контроллер (Model-View-Controller, **MVC**). В терминологии Django это будет Модель-Шаблон-Вид (Model-Template-View, **MTV**)
  * использование концепции приложений. Весь код рекомендуется оформлять в виде приложений и делать его подключаемым и переносимым
  * диспетчер URL на основе регулярных выражений
  * ORM для работы с БД (с поддержкой транзакций)
  * встроенный веб-сервер для разработки
  * встроенная административная панель

<!-- more -->

Установка и настройка Django
============================
**Django** можно установить двумя способами: из репозитариев или скачав исходники фреймворка с сайта. Как правило, в репозитариях находится не самая свежая версия. Поэтому, обычно используется второй способ, хотя это и не **Debian-way**.

Установка Django из репозитория
-------------------------------
Пакет Django находится в стандартном репозитории, поэтому ничего нового подключать не надо. Для установки необходимо выполнить следующее:

``` bash
    $ sudo aptitude install python-django
```
Установка последней стабильной версии Django
--------------------------------------------
Для установки последней версии необходимо скачать исходники и распаковать их:

``` bash
    $ sudo mkdir ~/django
    $ cd ~/django
    $ wget http://www.djangoproject.com/download/1.1/tarball/
    $ tar xzf Django-1.1.tar.gz
```
Далее, необходимо узнать, в какую директорию необходимо устанавливать пакеты, чтобы Python узнал об этом. Для этого необходимо выполнить:

``` bash
    $ python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"
    /usr/lib/python2.5/site-packages
```
В данном случае, видно что основной версией является Python 2.5 и все дополнительные пакеты устанавливаются в директорию "/usr/lib/python2.5/site-packages".

Следующим шагом необходимо создать символическую связь для распакованной директории Django:

``` bash
    $ sudo ln -s ~/django/Django-1.1/django /usr/lib/python2.5/site-packages/django
```
И в конце, чтобы сделать команду django-admin.py доступной из любой директории системы, необходимо добавить еще одну символическую ссылку:

``` bash
    $ sudo ln -s ~/django/Django-1.1/django/bin/django-admin.py /usr/local/bin
```
Проверка корректности установки Django
--------------------------------------
Чтобы убедиться, что Django нормально установлен, необходимо запустить интерпретатор Python и импортировать модуль django:

``` bash
    $ python -c "import django; print django.VERSION;"
    (1, 1, 0, 'final', 0)
```
Все в порядке. Последняя версия Django корректно установлена.

Установка и настройка Apache, mod_wsgi
======================================
Для работы с **Django** необходимы **http-сервер Apache** и модуль к нему - **mod-wsgi**. Модуль mod_wsgi пришел на смену mod_python и в настоящее время рекомендуется авторами Django как наиболее подходящее решение для использования в реальных условиях.

Установка Apache и mod_wsgi тривиальна:

``` bash
    $ sudo aptitude install apache2 libapache2-mod-wsgi
```
Установка MySQL
===============
Кроме самого сервера MySQL необходимо также установить пакет, который позволяет работать с MySQL из Python:

``` bash
    $ sudo aptitude install mysql-server python-mysqldb
```
При установке необходимо будет указать пароль для root-пользователя БД MySQL.

Создание и настройка проекта в Django
=====================================
При создании проекта будем исходить из того, что код Django-проекта должен работать от имени отдельного системного пользователя.

Создание проекта Django
-----------------------
Далее приведен код создание Django-проекта и некоторых дополнительных директорий в нем:

``` bash
    # директория для django проектов
    $ sudo mkdir -p /home/django-projects/debianworld_ru

    # новый django-проект
    $ cd /home/django-projects/debianworld_ru
    $ sudo django-admin.py startproject apps

    # корректируем название модуля для корректного импорта
    $ sudo perl -pi -e 's/apps.urls/urls/g' apps/settings.py

    # директория для настроек wsgi
    $ sudo mkdir -p /home/django-projects/debianworld_ru/deploy

    # директория для статики
    $ sudo mkdir -p /home/django-projects/debianworld_ru/media

    # директория для логов
    $ sudo mkdir -p /home/django-projects/debianworld_ru/logs
```

Создание пользователя для проекта
----------------------------------
Для того, чтобы изолировать код проекта от остальной системы (в целях безопасности), необходимо добавить в систему пользователя, от имени которого будет исполняться код проекта:

``` bash
    # создается системная группа
    $ sudo addgroup --quiet --system dw

    # создается системный пользователь
    $ sudo adduser --quiet --system --ingroup dw --no-create-home --no-create-home dw

    # новый владелец для проекта
    $ sudo chown dw:www-data -R /home/django-projects/debianworld_ru

    # права доступа на проект. Право на чтение для www-data необходимо
    # для корректной отдачи статики
    $ sudo chmod u=rwx,g=rx,o= -R /home/django-projects/debianworld_ru
```

Настройка виртуального хоста в Apache
-------------------------------------
Далее, чтобы код проекта отзывался на какой-либо URL-адрес, необходимо настроить виртуальный хост Apache.
Необходимо создать новый файл:

``` bash
    $ sudo -u dw vim /home/django-projects/debianworld_ru/deploy/debianworld.ru
```
И добавить в него следующий код:

``` apache
    <VirtualHost 10.1.0.4>
        # Описание сервера
        ServerAdmin admin@wsgi.debianworld.ru
        ServerName wsgi.debianworld.ru

        # Логи
        ErrorLog    /home/django-projects/debianworld_ru/logs/error_log
        CustomLog   /home/django-projects/debianworld_ru/logs/access_log common

        # wsgi-обработчик (см. ниже)
        WSGIScriptAlias / /home/django-projects/debianworld_ru/deploy/django.wsgi
        # Параметры запуска wsgi
        WSGIDaemonProcess dw-site user=dw group=dw home=/home/django-projects/debianworld_ru/media/ \
                          processes=2 threads=4 maximum-requests=100 display-name=apache-dw-wsgi
        WSGIProcessGroup dw-site

        # Статические файлы django-админки
        Alias "/media_admin/" "/usr/lib/python2.5/site-packages/django/contrib/admin/media/"
        <Location "/media_admin/">
            SetHandler None
        </Location>

        # Статические файлы проекта
        Alias "/media/" "/home/django-projects/debianworld_ru/media/"
        <Location "/media/">
            SetHandler None
        </Location>
    </VirtualHost>
```

В данном случае 10.1.0.4 - это IP-адрес машины, на которой работает Apache.

Настройка wsgi
--------------
Теперь, когда виртуальный хост создан, необходимо создать wsgi-обработчик. Для этого создается файл:

``` bash
    $ sudo -u dw vim /home/django-projects/debianworld_ru/deploy/django.wsgi
```
В файл добавляется следующий код:

``` python
    #/usr/bin/python
    # -*- coding: utf-8 -*-
    import os, sys

    # В python path добавляется директория проекта
    dn = os.path.dirname
    PROJECT_ROOT = os.path.abspath( dn(dn(__file__)) )
    DJANGO_PROJECT_ROOT = os.path.join(PROJECT_ROOT, 'apps')
    sys.path.append( DJANGO_PROJECT_ROOT )

    # Установка файла настроек
    os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

    # Запуск wsgi-обработчика
    import django.core.handlers.wsgi
    application = django.core.handlers.wsgi.WSGIHandler()
```


Включение виртуального хоста Apache
------------------------------------
На заключительном шаге необходимо дать знать о наличии нового виртуального хоста в Apache, включить его и перезагрузить сам Apache:

``` bash
    # Добавляет ссылку на виртуальный хост в список доступных хостов
    $ sudo ln -s /home/django-projects/debianworld_ru/deploy/debianworld.ru \
                 /etc/apache2/sites-available/debianworld.ru

    # включаем виртуальный хост
    $ sudo a2ensite debianworld.ru

    # рестарт Apache
    $ sudo /etc/init.d/apache2 restart
```

Проверка корректности установки
-------------------------------
Чтобы проверить, что Django корректно работает через mod_wsgi необходимо попытаться открыть URL "http://wsgi.debianworld.ru/" в браузере.

Результатом должно быть приглашение:

    It worked!
    Congratulations on your first Django-powered page.

    Of course, you haven't actually done any work yet. Here's what to do next:
      * If you plan to use a database, edit the DATABASE_* settings in settings/settings.py.
      * Start your first app by running python settings/manage.py startapp [appname].

Создание БД/пользователя в MySQL, настройка Django
--------------------------------------------------
После того, как есть уверенность, что Django установлен и работает, необходимо обеспечить возможность работы с БД. Для этого необходимо залогиниться в MySQL под root'ом:

``` bash
    $ mysql --user=root -p
```
И создать новую базу данных и нового пользователя:

``` sql
    mysql> CREATE DATABASE debianworld_db CHARACTER SET utf8;
    Query OK, 1 row affected (0.01 sec)

    mysql> CREATE USER debianworld_usr@localhost IDENTIFIED BY 'mega-secure-password';
    Query OK, 0 rows affected (0.00 sec)

    mysql> GRANT ALL ON debianworld_db.* TO debianworld_usr@localhost;
    Query OK, 0 rows affected (0.00 sec)
```

После того, как новые БД и пользователь готовы, необходимо прописать их в конфиг Django. Для этого необходимо открыть файл настроек:

``` bash
    $ sudo -u dw vim /home/django-projects/debianworld_ru/apps/settings.py
```
И прописать следующие значения:

``` python
    # ...
    DATABASE_ENGINE = 'mysql'                   # 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
    DATABASE_NAME = 'debianworld_db'            # Or path to database file if using sqlite3.
    DATABASE_USER = 'debianworld_usr'           # Not used with sqlite3.
    DATABASE_PASSWORD = 'mega-secure-password'  # Not used with sqlite3.
    DATABASE_HOST = ''                          # Set to empty string for localhost. Not used with sqlite3.
    DATABASE_PORT = ''                          # Set to empty string for default. Not used with sqlite3.
    # ...
```
Кроме того, чтобы правильно "подхватились" статические файлы django-админки и основго проекта, необходимо так же прописать:

``` python
    # ...
    MEDIA_URL = '/media/
    ADMIN_MEDIA_PREFIX = '/media_admin/'
    # ...
```
И в заключении, необходимо дать команду Django создать в БД основные таблицы:

``` bash
    $ sudo -u dw /home/django-projects/debianworld_ru/apps/manage.py syncdb
    Creating table auth_permission
    Creating table auth_group
    Creating table auth_user
    Creating table auth_message
    Creating table django_content_type
    Creating table django_session
    Creating table django_site

    You just installed Django's auth system, which means you don't have any superusers defined.
    Would you like to create one now? (yes/no): yes
    Username (Leave blank to use 'dw'): admin
    E-mail address: admin@wsgi.debianworld.ru
    Password:
    Password (again):
    Superuser created successfully.
    Installing index for auth.Permission model
    Installing index for auth.Message model
```

Вот и все. Теперь Django настроено полностью. Далее можно создавать приложения слдеующей командой:

``` bash
    $ sudo -u dw /home/django-projects/debianworld_ru/apps/manage.py startapp firstapp
```
или непосредственно под тем пользователем, под которым работает весь код проекта:

``` bash
    $ sudo -u dw bash
    $ cd /home/django-projects/debianworld_ru/apps/
    $ ./manage.py startapp firstapp
```
