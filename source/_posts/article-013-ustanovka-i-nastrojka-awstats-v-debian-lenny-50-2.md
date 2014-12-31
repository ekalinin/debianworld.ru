layout: post
title: Установка и настройка AWstats в Debian Lenny (5.0)-2
date: 2009-05-20
tags:
- debian-lenny
-  awstats
-  ubuntu
-  debian
-  статистика
categories: articles
permalink: ustanovka-i-nastrojka-awstats-v-debian-lenny-50-2

---

Продолжаем тему, начатую в [Установка и настройка AWstats в Debian](/articles/ustanovka-i-nastrojka-awstats-v-debian-lenny-50).

<!-- more -->

Дополнительная настройка AWstats
================================

Подключение плагинов
--------------------

Тот или иной плагин включается все в том же файле конфигурации, который располагается в */etc/awstats*. Плагинов и дополнительных настроек в AWstats предостаточно. Но в качестве обязательного посоветовать можно лишь следующие:

``` bash
    # Запуск обновления статистики из браузера
    AllowToUpdateStatsFromBrowser = 1
    # Язык интерфейса
    Lang="ru"
    # Декодирование поисковых фраз, по кот. был переход на сайт
    LoadPlugin="decodeutfkeys"
    # График стран на основе IP посетителей (снижает скорость работы анализатора на 10%!)
    LoadPlugin="geoipfree"
```
Для работа плагина *geoipfree* необходимо установить следующий perl модуль:

``` bash
    $ sudo aptitude install libgeo-ipfree-perl
```

Настройка ограничения доступа к AWstats через apache2
-----------------------------------------------------

Очевидно, что доступ к статистике сайта нужен не всем. Чтобы его (доступ) ограничить, необходимо отредактировать файл */etc/apache2/conf.d/awstats* и добавить туда следующие строки:

    <Location /cgi-bin>
        Options ExecCGI -MultiViews +SymLinksIfOwnerMatch

        AuthType Basic
        AuthName "AWStat. Auth users only"
        AuthUserFile /etc/apache2/.htpasswd
    
        Require valid-user
    </Location>

После чего необходимо создать файл с пользователями, которым будет дан доступ к статестике AWstats:

``` bash
    $ sudo htpasswd -c /etc/apache2/.htpasswd shorrty
    $ sudo htpasswd /etc/apache2/.htpasswd kev
```
Запуск анализа логов и генерации статистики AWstats по расписанию (cron)
------------------------------------------------------------------------

Файл задания анализа лого и генерации статстики AWstat уже идет в комплекте и лежит тут: /etc/cron.d/awstats. 
По умолчанию, файл выглядит следующим образом:

``` bash
    0,10,20,30,40,50 * * * * www-data [ -x /usr/lib/cgi-bin/awstats.pl \
                                                          -a -f /etc/awstats/awstats.conf \
                                                          -a -r /var/log/apache/access.log ] && \
                                                       /usr/lib/cgi-bin/awstats.pl -config=awstats -update >/dev/null
```
То есть, каждые 10 минут:

  1. проверяется, что:
      - файл /usr/lib/cgi-bin/awstats.pl является исполняемым
      - файл /etc/awstats/awstats.conf сущестует и является обычным файлом
      - файл /var/log/apache/access.log доступен на чтение
  2. В случае выполнения всех трех условия из предыдущего пункта, запускается скрипт обновления статистики awstats.pl с конфигом awstats.

Необходимо изменить этот файл исходя из следующим соображения:

  1. Необходимо указать свой конфиг, а не дефолтный
  2. Генерация статистики каждые 10 минут не обязательна. Достаточно обновлять ее раз в сутки, к тому же с помощью настроек в интерйефс добавлена возможность ручного запуска обновления статистики.

Таким образом, итоговый результат должен быть следующим (на примере DebianWorld.Ru):

    0 2 * * * www-data [ -x /usr/lib/cgi-bin/awstats.pl \
                               -a -f /etc/awstats/awstats.debianworld.ru.conf \
                               -a -r /var/www/debianworld.ru/logs/apache_access.log ] && \
                             /usr/lib/cgi-bin/awstats.pl -config=debianworld.ru -update >/dev/null
