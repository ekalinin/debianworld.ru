layout: post
title: Установка и настройка mercurial и Apache через mod_wsgi в Debian / Ubuntu
date: 2009-08-14
tags:
- ubuntu
-  debian
-  mercurial
-  apache
-  mod_wsgi
-  контроль-версий
categories: articles
permalink: ustanovka-i-nastrojka-mercurial-i-apache-cherez-mod_wsgi-v-debian-ubuntu
---
**Mercurial** - это **распределённая система управления версиями** (**DCVS**). Разрабатывалась специально для больших проектов. Таким образом, одной из отличительных особенностей **Mercurial** является скорость работы. БОльшая часть системы написана на **Python**, а чувствительные к производительности части - реализованы  в качестве Python-расширений на C.

Наравне с традиционными возможностями систем контроля версий, **Mercurial** так же поддерживает функции для децентрализованной работы:

  * отсутствует понятие основного хранилища кода
  * ветвление (возможно вести несколько веток одного проекта и копировать изменения между ветками)
  * слияние репозиториев (чем и достигается «распределённость» работы). 

Кроме того, **Mercurial** предоставляет Web-интерфейс, а так же встроенную систему подсказок. Большинство команд привычны для пользователей CVS.

<!-- more -->
Установка и настройка mercurial
======================

Установка mercurial
------------------------
Установка mercurial очень проста:

``` bash
    $ sudo aptitude install mercurial
```
Настройка mercurial
------------------------
Далее, необходимо создать пользователя для mercurial и директории, где будут располагаться **репозитории mercurial** и виртуальный хост (последний необходим для настройки apache, см. далее):

``` bash
    # добавляем нового пользователя
    $ sudo useradd hg
    $ sudo mkdir /home/hg
    $ sudo chown hg:hg /home/hg
```
    # создаем директорим для репозиториев и для виртуального хоста
    $ sudo -u hg mkdir /home/hg/rep /home/hg/www


Создание репозитория mercurial
======================
После того, как пользователь создан, необходимо создать репозиторий, в котором будут храниться исходные коды:

``` bash
    # От имени пользователя hg создаем (hg init) репозиторий
    $ sudo -u hg hg init /home/hg/rep/Debian.World.Ru
```
Попробуем что-нибудь сохранить в репозитории:

``` bash
    $ sudo su - hg
    $ cd /home/hg/rep/Debian.World.Ru/
    
    # создаем файл
    $ echo "test mercurial cvs" > read.me
```
    # убеждаемся, что mercurial "видит" новый файл
    $ hg status
    ? read.me
   
    # добавляем файл в репозиторий
    $ hg add
    adding read.me

    # убеждаемся, что добавление файла выполнено
    $ hg status
    A read.me

    # коммитим изменения
    $ hg ci -m "init revision"
    No username found, using 'hg@debian-world.ru' instead

Последняя строчка выглядит странновато, но волноваться не очем. Все изменения будут сохранены, а последняя строчка говорит лишь о том, что вместо имени ползователя будет использована строка "hg@debian-world.ru", то есть "логин@машина". Чтобы эта строка более не мозолила глаз, необходимо лишь сделать следующее:

``` bash
    $ echo "[ui]" > ~/.hgrc
    $ echo "username = Debian.World.Ru Admin <debian.world.ru@gmail.com>" >> ~/.hgrc
```
Таким образом, mercurial будет "знать", кем подписываться при сохранении изменений.

Установка и настройка Apache, mod_wsgi
============================
После того, как репозиторий создан, необходимо предоставить http-доступ к нему. 

Установка Apache, mod_wsgi
-----------------------------------
Для этого необходимо установить http-сервер, например, Apache, а так же модуль для работы с python (в данном случае - mod_wsgi):

    $ sudo aptitude install apache2 libapache2-mod-wsgi

Настройка Apache
----------------------
Далее, необходимо создать виртуальный хост:

``` bash
    $ sudo touch /etc/apache2/sites-available/mercurial
```
Выглядеть он должен приблизительно следующим образом:

``` apache
    <VirtualHost *:80>
        ServerAdmin debian.world.ru@gmail.com
        ServerName hg.debianworld.ru
        DocumentRoot /home/hg/www/
```
        # настройки wsgi
        WSGIProcessGroup hg
        WSGIDaemonProcess hg user=hg group=hg threads=2 maximum-requests=1000

        # путь до скрипта, обрабатывающий wsgi
        WSGIScriptAlias / /home/hg/rep/hgwebdir.wsgi

        # ограничение доступа к репозиторию
        <Location />
            AuthType Basic
            AuthName "Restricted Files"
            AuthUserFile /home/hg/.hg.htpasswd
            Require valid-user
        </Location>
    </VirtualHost>

Настройка mod_wsgi
------------------------
После того, как создан виртуальных хост, необходимо создать скрипт wsgi, а так же файл пользователей, которым будет доступен репозиторий.
Скрипт для wsgi можно располагать в любом месте, например, недалеко от репозитория:

``` bash
    $ sudo -u hg vim /home/hg/rep/hgwebdir.wsgi
```
Выглядеть он должен следующий образом:

``` python
    #!/usr/bin/python
    # -*- coding: utf-8 -*-
```
    import os
    os.environ['HGENCODING'] = 'utf-8'

    from mercurial.hgweb.hgwebdir_mod import hgwebdir
    from mercurial.hgweb.request import wsgiapplication

    path = os.path.dirname(os.path.abspath(__file__))
    application = hgwebdir(path+'/hgwebdir.conf')

Радом необходимо создать файл конфигации web-интерфейса репозитория:

``` bash
    $ sudo -u hg vim /home/hg/rep/hgwebdir.conf
```
Выглядеть он должен следующим образом:

``` ini
    [web]
    style = coal
    
    [paths]
    DebianWorld.Ru = /home/hg/rep/Debian.World.Ru
```
После этого можно включить виртуальный хост и перегрузить apache:

``` bash
    $ sudo a2ensite mercurial
    $ sudo /etc/init.d/apache2 reload
```
Настройка доступа к mercurial
---------------------------------------
На завершающей стадии настройки, необходимо создать файл паролей, указанный в описании виртуального хоста:

``` bash
    $ htpasswd -c /home/hg/.hg.htpasswd hgviewer
```
Теперь можно работать с репозитарием как через браузер, так и через командную строку, обращаясь к репозиторию по адресу: http://hg.debianworld.ru/DebianWorld.Ru/. Например:

``` bash
    # Просмотр репозитариев браузером
    $ lynx http://hg.debianworld.ru/DebianWorld.Ru
```
    # Копирование репозитория клиентом mercurial
    $ hg clone http://hg.debianworld.ru/DebianWorld.Ru
    destination directory: DebianWorld.Ru
    http authorization required
    realm: Restricted Files
    user: 
    password:
