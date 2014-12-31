layout: post
title: Установка и настройка доступа к mercurial по http через nginx в Debian / Ubuntu
date: 2009-10-21
tags:
- debian
-  ubuntu
-  nginx
-  mercurial
-  контроль-версий
categories: articles
permalink: ustanovka-i-nastrojka-dostupa-k-mercurial-po-http-cherez-nginx-v-debian-ubuntu
---
**Mercurial** - это кросплатформенная **распределённая система управления версиями** (DCVS). Основная часть кода написана на языке **Python**, а наиболее чувствительные к производительности части выполнены в качестве Python-расширений на C. В настоящее время **Mercurial** используют такие проекты, как: **Python**, **Netbeans**, **Mozilla и Mozdev**, **OpenOffice.org** и многие другие.

Одной из самых распространенных задач, возникающих после установки **Mercurial** является настройка доступа к репозиториям по http-протоколу. Эта задача с точки зрения [доступа на чтение уже описывалась ранее] (http://debianworld.ru/articles/ustanovka-i-nastrojka-mercurial-i-apache-cherez-mod_wsgi-v-debian-ubuntu/ "Организация доступа на чтение к  Mercurial через Apache/mod_wsgi"). Далее будет описан вариант доступа на чтение/запись с помощью http-сервера nginx. 
<!-- more -->
Общая схема развертывания следующая: 

  * http-сервер nginx будет принимать все соединения с Mercurial
  * для запросов на изменение nginx будет запрашивать логин/пароль
  * запросы на чтение и успешные запросы на запись будут проксироваться на встроенный в Mercurial http-сервер

Установка Nginx, Mercurial
==================
В первую очередь необходимо установить http-сервер nginx и mercurial:

``` bash
    $ sudo aptitude  install nginx mercurial
```
Настройка Mercurial
===========
После того, как система контроля установлена, необходимо обеспечить безопасный доступ к репозиториям.

Пользователь и директория для репозиториев Mercurial
---------------------------------------------------------------------
В первую очередь, необходимо создать нового пользователя, в домашнем каталоге которого будут находиться все репозитории mercurial:

``` bash
    $ sudo adduser --home /home/hg --disabled-password hg
```
Далее, необходимо создать директории  для репозиториев и лог-файлов:

``` bash
    $ sudo -u hg mkdir /home/hg/repos
    $ sudo -u hg mkdir /home/hg/logs
```
И в конце, выставить права доступа на директории:

``` bash
    $ sudo chmod u=rwx,g=rwx,o= -R /home/hg
```
Не лишним так же будет добавить информацию о пользователе mercurial:

``` bash
    $ sudo su - hg
    $ echo "[ui]" >  ~/.hgrc
    $ echo "username = DebianWorld.Ru <debian.world.ru@gmail.com>" >> ~/.hgrc
```
Новый репозиторий Mercurial
-----------------------------------
После того, все подготовительный процедуры выполнены, можно создавать репозиторий и делать первую правку в нем

``` bash
    # Все действия будут выполняться от пользователя hg
    $ sudo su - hg
```
    # Создается новый репозиторий
    $ hg init ~/repos/Debian.World.Ru

    # Вносится изменение - создается новый файл
    $ cd ~/repos/Debian.World.Ru/
    $ echo "Mercurial on DebianWorld.Ru" > read.me

    # Проверка видимости изменений
    $ hg status
    ? read.me

    # Добавление файла в репозиторий
    $ hg add
    adding read.me

    # Внесение изменений в проект
    $ hg ci -m "init revision"

Настройка доступа к репозиториям mercurial
-----------------------------------------------------
После того, как репозиторий создан и сделаны первые правки, можно приступать к настройке доступа по http. В первую очередь создается файл настроек для публикации проектов:

``` bash
    # продолжается выполнение команд от пользователя hg
    $ vim ~/repos/hgweb.config
```
В него вносится информация о том, где располагаются имеющиеся репозитотрии (в нашем случае он один, но теоретически их может быть много):
  
``` apache
    [collections]
    /home/hg/repos = /home/hg/repos
```
Левая часть - это префикс пути, который надо убрать из URL адреса. Правая часть - полный путь к каталогу, где содержатся репозитории. 
Например, если была бы строка / = /home/hg/repos, то URL репозитория был бы http://hg.debianworld.ru/home/hg/repos/DebianWorld.Ru. А так, указывая, что надо исключать /home/hg/repos, новый URL репозитория будет http://hg.debianworld.ru/DebianWorld.Ru.

Далее, в проекте пишем права доступа. Открываем файл:

``` bash
    # продолжается выполнение команд от пользователя hg
    $ vim ~/repos/Debian.World.Ru/.hg/hgrc
```
Пишем:

``` apache
    [web]
    style = gitweb
    push_ssl = false
    allow_push = *
```
Таким образом:

  * отключается SSL (чего вполне достаточно для большинства не коммерческих проектов)
  * позволяется выполнять изменения всем пользователям, так как функцию аутентификации берет на себя nginx (см. далее)

Настройка Nginx
===========
Следующим шагом, необходимо настроить nginx на прием соединений к репозиториям, проверку логина/пароля при внесении изменений и проксирование содинение на встроенный сервер Mercurial.

Создание виртуального хоста Nginx
--------------------------------------------
Чтобы создать виртуальный хост, необходимо создать файл:

``` bash
    $ sudo vim /etc/nginx/sites-available/hg.debianworld.ru
```
И вписать в него:

``` apache
    upstream backend {
        # адрес mercurial http-севера
        server 127.0.0.1:8080;
    }
```
    server {
        listen      80;
        server_name hg.debianworld.ru;
        access_log  /home/hg/logs/nginx_access.log;
        error_log   /home/hg/logs/nginx_error.log crit;

        location / {
            # ограничение доступа на запись
            limit_except GET {
                auth_basic           "Restricted";
                auth_basic_user_file /etc/nginx/.hg.htpasswd;
                proxy_pass           http://backend;
            }
            proxy_pass  http://backend;
        }
    }

Далее, необходимо включить хост:

``` bash
    $ sudo ln -s /etc/nginx/sites-available/hg.debianworld.ru \
                         /etc/nginx/sites-enabled/hg.debianworld.ru
```
Чтобы новый хост заработал, необходимо перестартовать nginx:

``` bash
    $ sudo /etc/init.d/nginx restart
```
Настройка учетных записей (htpasswd)
----------------------------------------------
Следующим шагом необходимо заполнить файл учетных записей, которым позволено вносить изменения в репозиторий. Делается это с помощью утилиты htpasswd. Если apache никогда не устанавливался на машине, то необходимо установить пакет apache2-utils, чтобы была возможность работать с этой утилитой:

``` bash
    $ sudo aptitude install apache2-utils
```
После того, как пакет поставлен, можно создавать пользователей:

``` bash
    # Создается файл учетных записей и вносится пользователь hgviewer
    $ sudo htpasswd -c /etc/nginx/.hg.htpasswd hgviewer
```
    # Вносится пользователь hgother
    $ sudo htpasswd /etc/nginx/.hg.htpasswd hgother


Запуск встроенного сервера Mercurial
=========================
После того, как настроен mercurial,nginx и создан файл паролей, можно запускать встроенный в mercurial http-сервер на 8080 порту:

``` bash
    $ sudo -u hg hg serve --webdir-conf /home/hg/repos/hgweb.config \
                   --address 127.0.0.1 --port 8080 --encoding utf8
```
Сервер запускается от пользователя hg, чтобы был доступ к репозиторию и правки вносились от его имени. указывается файл конфигурации доступных проектов. Для корректного отображения русских символов указывается кодировка utf8. Кроме того, если добавить опцию "--daemon", то сервер Mercurial будет работать как демон.

Проверка доступа к репозиторию по http
===========================
Все ниже следующие операции будут выполняться на удаленной машине, то есть не на той, где расположен Mercurial. 

Получение исходного кода:

``` bash
    $ hg clone http://hg.debianworld.ru/Debian.World.Ru/
    destination directory: Debian.World.Ru
    requesting all changes
    adding changesets
    adding manifests
    adding file changes
    added 1 changesets with 1 changes to 1 files
    updating working directory
    1 files updated, 0 files merged, 0 files removed, 0 files unresolved
```

Создание локальных изменений:

``` bash
    $ cd Debian.World.Ru
    $ echo "123" >> read.me
    $ hg status
    M read.me
    $ hg commit -m "second commit"
```
Внесение изменений в проект:

    ##bash##
    $ hg push
    pushing to http://hg.debianworld.ru/Debian.World.Ru/
    searching for changes
    http authorization required
    realm: Restricted
    user: hgother
    password:
    adding changesets
    adding manifests
    adding file changes
    added 1 changesets with 1 changes to 1 files
