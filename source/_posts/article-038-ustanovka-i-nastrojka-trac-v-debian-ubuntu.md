layout: post
title: Установка и настройка Trac в Debian / Ubuntu
date: 2009-08-10
tags:
- trac
-  debian
-  subversion
-  ubuntu
-  apache
-  баг-трекинг
-  контроль-версий
categories: articles
permalink: ustanovka-i-nastrojka-trac-v-debian-ubuntu
---
**Trac** - это **система управления проектами** разработки программного обеспечения, вкючающая в себя возможность **отслеживания ошибок** и просмотра репозитариев систем контроля версий (**subversion** "из коробки", **mercurial**, **git**, **bazaar** через плагины). Реализована средствами языка **Python** и распространяется в открытых исходных кодах. 

**Trac** предоставляет такие функции, как:

  * разделение проекта на этапы (milestones)
  * план работ (roadmap)
  * история изменений (timeline)
  * управление пользователями
  * учет задач на разработку (tickets)
  * wiki

**Trac** поддерживает **wiki разметку** в описании задач и commit'ов, а так же позволяет создавать связи (links) между задачами (tickets), изменениями (changesets), файлами (files) и wiki-страницами (wiki pages).
<!-- more -->
Установка и настройка Subversion
=======================
Установка Subversion:

``` bash
    $ sudo aptitude install subversion
```
В результате будет установлена следующая версия:

``` bash
    dpkg -l subversion | grep ii
    ii  subversion                        1.5.1dfsg1-4             Advanced version control system
```
Далее, необходимо создать группу для subversion, и добавить в нее необходимых пользователей:

``` bash
    $ sudo groupadd subversion
    $ sudo addgroup dw subversion
```
После того, как Subversion установлен, можно создавать репозитарии:

``` bash
    $ sudo mkdir /var/svn-repos/
    $ sudo svnadmin create --fs-type fsfs /var/svn-repos/debian.world.ru
```
Далее, необходимо ограничить доступ к репозитарию:

``` bash
    # Разрешатся доступ к репозитарию только 
    # http-серверу (www-data) и аккаунтам из группы subversion
    $ sudo chown -R www-data:subversion /var/svn-repos/*
    $ sudo chmod -R 770 /var/svn-repos/*
```
Установка и настройка Trac
==================

Установка Trac
------------------
Для начала необходимо **установить Trac** со всеми его зависимостями (а их немало):

``` bash
    $ sudo aptitude install trac
```
В результате будет установлена следующая версия:

``` bash
    $ dpkg -l | grep "trac "
    ii  trac                              0.11.1-2.1               Enhanced wiki and issue tracking system for
```
Кроме **Trac**, будут так же установлены следующие пакеты:

  * **apache2** (2.2.9-10+lenny4) - *http сервер*
  * **libjs-jquery** (1.2.6-2) - *JavaScript библиотека jquery*
  * **python-genshi** (0.5.1-1) - *Система html шаблонов*
  * **python-pygments** (0.10-1) - *Система подсветки исходного кода*
  * и д.р.

Настройка Trac
------------------
Первым делом, необходимо создать директорию, где будут хранитсья **описания проектов Trac**:

``` bash
    $ sudo mkdir /var/trac
```
Далее, можно создавать сами проекты:

``` bash
    # Создаем проект с именем "Debian.World.Ru"
    $ sudo trac-admin /var/trac/Debian.World.Ru initenv
```
    # Даем доступ к проекту пользователям http-сервера и subversion
    $ sudo chown -R www-data:subversion /var/trac
    $ sudo chmod -R 770 /var/trac

При создании проекта, необходимо отчетить на такие вопросы, как:

  * **Project Name (Имя проекта)** - DebianWorld.Ru
  * **Database connection string (Строка соединения с БД)** - оставить без изменений, чтобы использовать sqlite
  * **Repository type (Тип репозитория)** - оставить без изменений, чтобы использовать subversion
  * **Path to repository (Путь к репозиторию)** - /var/svn-repos/debian.world.ru

Проверям работу trac, запуская http-сервер:

``` bash
    $ sudo -u www-data tracd --port 8000 /var/trac/Debian.World.Ru/
    Server starting in PID 4722.
    Serving on 0.0.0.0:8000 view at http://127.0.0.1:8000/
```
Далее, необходимо открыть в браузере: http://127.0.0.1:8000/, и убедиться, что Trac установлен и работает.

Добавление пользовтелей в Trac
----------------------------------------
Trac использует систему разграничений прав, поэтому необходимо добавить, как минимум, администратора:

``` bash
    $ sudo trac-admin /var/trac/Debian.World.Ru/ permission add dw TRAC_ADMIN
```
Настройка Apache
============

Установка mod_python
----------------------------
Для того, чтобы можно было работать с Trac через Apache, нобходимо установить модуль apache для работы с python:

``` bash
    $ sudo aptitude install libapache2-mod-python
```
Настройка доступа к Trac в Apache
------------------------------------------
Следующим этапом, необходимо настроить виртуальный хост apache для доступа к Trac:

``` bash
    $ sudo vim /etc/apache2/sites-available/trac
```
Конфиг должен выглядеть приблизительно следующим образом:

``` apache
    <VirtualHost *:80>
        DocumentRoot "/var/trac"
        ServerName trac.debianworld.ru
        <Location />
            # настройка окружения для Trac
            SetHandler mod_python
            PythonInterpreter main_interpreter
            PythonHandler trac.web.modpython_frontend
            PythonOption TracEnv /var/trac/Debian.World.Ru
            PythonOption TracUriRoot /
            
            # ограничение доступа к Trac
            AuthType Basic
            AuthName "Trac Server"
            AuthUserFile /etc/apache2/trac.passwd
            Require valid-user
        </Location>
    </VirtualHost>
```

Далее, необходимо добавить пользователей, у которых есть доступ к Trac:

``` bash
    # Создается файл пользователей и добавляется пользователь
    $ sudo htpasswd -c /etc/apache2/trac.passwd dw
```
    # Добавляется пользователь, файл не создается
    $ sudo htpasswd /etc/apache2/trac.passwd user2

И в заключении, необходимо включить виртуальный хост и перезагрузить apache:

``` bash
    $ sudo a2ensite trac
    $ sudo /etc/init.d/apache2 reload
```
После этого, Trac будет доступен по адресу: http://trac.debianworld.ru