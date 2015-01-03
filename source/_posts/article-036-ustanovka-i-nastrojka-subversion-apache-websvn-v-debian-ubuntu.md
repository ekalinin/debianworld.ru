layout: post
title: Установка и настройка Subversion, Apache, WebSvn в Debian / Ubuntu
date: 2009-07-08
tags:
- subversion
- apache
- websvn
- debian
- ubuntu
- контроль-версий
categories: articles
permalink: ustanovka-i-nastrojka-subversion-apache-websvn-v-debian-ubuntu

---

**Subversion** - централизованная система управления версиями, распространяемая в исходных кодах. Так же иногда называется **svn**, по названию клиентской программы, входящей в стандартный дистрибутив **Subversion**. Разрабатывалась, как альтернатива системе **CVS**, обладающая всеми основными функциями **CVS** и свободная от ряда её недостатков.

В настроящее время **Subversion** используется во многих известных проектах: Apache, Samba, Google Code, SourceForge.net и многих других.

**WebSvn** - онлайн **subversion клиент**. По сути, есть не что иное, как набор **PHP скриптов**, предоставляющий удаленный доступ к репозиториям **Subversion**. Поддерживается работа с несколькими репозитариями, допускается редактирование шаблонов интерфейса, поддерживется опция Apache MultiViews и предоставляется возможность экспорта в RSS.

<!-- more -->

Установка Subversion
====================
Установка Subversion классически проста:

``` bash
    $ sudo aptitude install subversion
```
Следующим шагом необходимо создать группу для subversion, и добавить в нее необходимых пользователей:

``` bash
    $ sudo groupadd subversion
    $ sudo addgroup dw subversion
```
Создание репозитария в Subversion
=================================
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
Установка и настройка Apache, WebDAV для доступа к Subversion
=============================================================
Необходимо установить не только apache2, но и модуль svn-сервера для apache:

``` bash
    $ sudo aptitude install apache2 libapache2-svn
```
Далее, необходимо включить модули для работы с WebDAV:

``` bash
    $ sudo a2enmod dav
    $ sudo a2enmod dav_svn
```
Следующим шагом, необходимо настроить политику доступа к репозитариям subversion через apache. Для  этого необходимо отредактировать следующий файл конгурации apache:

``` bash
    $ sudo vim /etc/apache2/mods-available/dav_svn.conf
```
По умолчанию, в файле все закомментировано. Необходимо расскомментировать необходимые строки, чтобы в результате получилось что-то похожее на следующее:

``` apache
    <Location /svn>
      # Включение доступа к репозиторию subversion
      DAV svn

      # Путь к конкретному репозиторию
      #SVNPath /var/lib/svn

      # Альтернатива SVNPath. Если необходимо доступ к нескольких репозиториям,
      # располагающимся в одной директории.
      # Задается либо SVNPath, либо SVNParentPath. Оба параметра одновременно
      # задавать нельзя.
      SVNParentPath /var/svn-repos

      # Включение аутентификации
      AuthType Basic
      AuthName "Subversion Repository"
      AuthUserFile /etc/apache2/dav_svn.passwd
      Require valid-user
    </Location>
```
Далее, необходимо задать пользователей, которым разрешен доступ к subversion через apache:

``` bash
    # Создается файл пользователей и добавляется пользователь user1
    $ sudo htpasswd -c /etc/apache2/dav_svn.passwd user1

    # Добавляется пользователь user2
    $ sudo htpasswd /etc/apache2/dav_svn.passwd user2
```

В заключении, необходимо перестартовать apache, чтобы все изменения вступили в силу:

``` bash
    $ sudo /etc/init.d/apache2 restart
```
Проверка доступа к Subversion
=============================
Первым шагом, необходимо создать типовую структуру проекта в subversion и импортировать её:

``` bash
    $ mkdir -p ~/svn-start/branches ~/svn-start/tags/ ~/svn-start/trunk/
    $ svn import -m "init " ~/svn-start/ http://localhost/svn/debian.world.ru/
```
В конце проверяем, что хранилище доступно на чтение и структура проекта совпадает с той, что импортировалась ранее:

``` bash
    $ svnlook tree /var/svn-repos/debian.world.ru
    /
     trunk/
     branches/
     tags/
```

Продолжение [тут](/articles/ustanovka-i-nastrojka-subversion-apache-websvn-v-debian-ubuntu-2)
