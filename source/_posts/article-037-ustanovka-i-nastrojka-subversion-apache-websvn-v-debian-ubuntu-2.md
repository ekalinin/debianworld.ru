layout: post
title: Установка и настройка Subversion, Apache, WebSvn в Debian / Ubuntu -2
date: 2009-07-08
tags:
- subversion
- apache
- websvn
- debian
- ubuntu
- контроль-версий
categories: articles
permalink: ustanovka-i-nastrojka-subversion-apache-websvn-v-debian-ubuntu-2

---

Продолжаем тему, начатую в [Установка и настройка Subversion, Apache, WebSvn](/articles/ustanovka-i-nastrojka-subversion-apache-websvn-v-debian-ubuntu)

<!-- more -->

Установка и настройка WebSvn
============================

Установка WebSvn
----------------
Установка WebSvn достаточно проста:

``` bash
    $ sudo aptitude install websvn enscript
```
Пакет enscript необходим для подстветки синтаксиса.

В процессе установки будут заданы несколько вопросов, в частности:

  * для какого типа сервера **настраивается WebSvn** - необходимо просто нажать enter
  * родительская директория для subversion репозитариев - необходимо задать: "/var/svn-repos". Таким образом, все репозитории, которые появятся в этой директории, будут доступны для просмотра через WebSvn.
  * путь к конкретному репозитарию - необходимо оставить пустым, если нет необходимости ограничивать выбор только конкретными репозиториями. В противном случае, необходимо указать полные пути к репозиториям.

Результат настройки будет сохранен в файле **/etc/websvn/svn_deb_conf.inc**.
Сразу после установки, все репозитории будут доступны по адресу: *http://localhost/websvn/*.

Настройка WebSvn: ограничение доступна
--------------------------------------
Однако полный доступ к репозитариям - это не всегда хорошо. В случае, если репозитарий не публичный, необходимо ограничить **доступ к WebSvn** только для конкретных пользователей. Для этого необходимо отредактировать файл **/etc/apache2/conf.d/websvn**:

``` bash
    $ sudo vim /etc/apache2/conf.d/websvn
```
Результируйющие файл конфигурации должен иметь приблизительно следующий вид:

``` apache
    Alias /websvn /usr/share/websvn

    <Directory /usr/share/websvn>
      AuthType Basic
      AuthName "Subversion Repository"
      AuthUserFile /etc/apache2/dav_svn.passwd
      Require valid-user

      DirectoryIndex index.php
      Options FollowSymLinks

      <IfModule mod_php4.c>
        php_flag magic_quotes_gpc Off
        php_flag track_vars On
      </IfModule>
    </Directory>
```

Настройка WebSvn: редактирование шаблона
----------------------------------------
**WebSvn** из коробки поддерживает русский язык. Поэтому минимум необходимых настроек - это корректировка шаблона для вывода приемлимого описания проектов на главной странице WebSvn. По умолчанию, оно на английском языке и о чем не говорит пользователю, работающему с webSVN. Поэтому необходимо отредактировать следующий файл (по умолчанию используется шаблон calm):

``` bash
    $ sudo vim /usr/share/websvn/templates/calm/index.tmpl
```
Очевидно, что можно отредактировать весь шаблон по своему усмотрению, но для того, чтобы скорректировать описание достаточно уделить внимание лишь следующему фрагменту:

``` html
    ...

    <div id="info">
    <h2>About</h2>
    <dl>
      <dt>Summary:</dt>
      <dd>
           You can customize this short message in the index.tmpl
           of this template in order to tell your visitors what they
           find in your repositories.
      </dd>
      <dd>
          Visit <a href="http://websvn.tigris.org">websvn.tigris.org</a>
          for more information about WebSVN.
      </dd>
      <dd>
          Learn more about Subversion at <a href="http://subversion.tigris.org">
          subversion.tigris.org</a>.
      </dd>
    </dl>
    </div>

    ...
```

Результат, например, может иметь следующий вид:

``` html
    ...

    <div id="info">
    <h2>О репозитарии</h2>
    <dl>
      <dt>
         Пример настройки WebSvn на Debain / Ubuntu для проекта
         <a href="http://debianworld.ru/"> Все о Debain / Ubuntu </a>.
      </dt>
    </dl>
    </div>


    ...
```

Более подробно о правилах редактирования шаблонов WebSvn можно узнать из документации: **/usr/share/doc/websvn/templates.txt.gz**.
