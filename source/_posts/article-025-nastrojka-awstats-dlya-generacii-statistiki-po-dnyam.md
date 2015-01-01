layout: post
title: Настройка AWstats для генерации статистики по дням
date: 2009-06-17
tags:
- awstats
- debian
- ubuntu
- статистика
categories: articles
permalink: nastrojka-awstats-dlya-generacii-statistiki-po-dnyam

---

**AWstats** - одна из открытых **систем сбора и анализа статистики посещений** web-сайтов. [AWstats проста в установке и настройке](http://debianworld.ru/articles/ustanovka-i-nastrojka-awstats-v-debian-lenny-50/ "Установка и настройка AWStats"), что уже было рассмотрено ранее. В базовой настройке **AWstats** создает сводную статистику за месяц, но, как правило, возникает необходимость **анализа статистики посещений по дням**.

Начиная с версии 6.5 появилась такая возможность.

<!-- more -->

К сожалению, данная возможность реализована еще не в полном объеме. Поэтому она не описана в документации. Недоделанность выражается в том, что в интерфейсе нельзя навигироваться по дням, по которым была сгенерирована дневная статистика. Но при этом, просмотр статистики доступен, если знать, какие дополнительные параметры необходимо указать в URL-строке. Но обо всем по порядку.

Нововведения в AWstats для генерации ежедневной статистики
==========================================================
Начиная с версии 6.5, **AWstats** поддерживает параметр **DatabaseBreak**. Этот параметр отвечает за процесс создания промежуточных данных статистических данных для создания отчетов по часам, дням, месяцам и за год. Поддерживаются следующие значения параметра:

  - hour
  - day
  - month
  - year

Таким образом, варьируя значением этого параметра можно добиться необходимой точности отчетов посещений.

Настройка AWstats для генерации ежедневной и почасовой статистики
=================================================================
Чтобы **AWstats** начал создавать статистику с уровнем детализации, отличным от дефолтного - месяц, необходимо в коммандной строке, выставить параметр DatabaseBreak.

В рассмотренной ранее статье по [установке и настройке AWstats](http://debianworld.ru/articles/ustanovka-i-nastrojka-awstats-v-debian-lenny-50/ "Установка и настройка AWStats"), для генерации статистики выполнялась следующая команда:

``` bash
    $ sudo -u www-data /usr/bin/perl /usr/lib/cgi-bin/awstats.pl -update -config=debianworld.ru
```
При этом, статистика генерировалась за текущий месяц и в директории, заданной параметром **DirData** (значение было: */var/www/debianworld.ru/awstats*), появлялись файлы вида:

``` bash
    $ ls -l /var/www/debianworld.ru/awstats
    -rw-r--r-- 1 root     www-data 13820 Июн  1 05:20 awstats052009.debianworld.ru.txt
    -rw-r--r-- 1 root     www-data 42455 Июн 13 09:47 awstats062009.debianworld.ru.txt
```
Эти файлы и есть данные о помещениях за месяц.

Теперь, чтобы добиться сразу и дневной и почасовой статистики, необходимо запустить **AWstats** следующим образом:

``` bash
    $ sudo -u www-data /usr/bin/perl /usr/lib/cgi-bin/awstats.pl -update -config=debianworld.ru -DatabaseBreak=hour
    $ sudo -u www-data /usr/bin/perl /usr/lib/cgi-bin/awstats.pl -update -config=debianworld.ru -DatabaseBreak=day
```
Теперь, если посмотреть на содежимое директории данных AWstats, то там появятся новые файлы:

``` bash
    $ ls -l /var/www/debianworld.ru/awstats
    -rw-r--r-- 1 root     www-data 13820 Июн  1 05:20 awstats052009.debianworld.ru.txt
    -rw-r--r-- 1 root     www-data  6001 Июн 13 09:48 awstats0620091300.debianworld.ru.txt
    -rw-r--r-- 1 root     www-data  6200 Июн 13 09:48 awstats0620091301.debianworld.ru.txt
    -rw-r--r-- 1 root     www-data  6051 Июн 13 09:48 awstats0620091302.debianworld.ru.txt
    -rw-r--r-- 1 root     www-data  5922 Июн 13 09:48 awstats0620091303.debianworld.ru.txt
    -rw-r--r-- 1 root     www-data  6308 Июн 13 09:48 awstats0620091304.debianworld.ru.txt
    #...
    -rw-r--r-- 1 root     www-data  6662 Июн 13 09:48 awstats0620091323.debianworld.ru.txt
    -rw-r--r-- 1 root     www-data 13482 Июн 13 09:48 awstats06200913.debianworld.ru.txt
    #...
    -rw-r--r-- 1 root     www-data 42455 Июн 13 09:47 awstats062009.debianworld.ru.txt
```
где:

  - *awstats0620091300.debianworld.ru.txt* - статистика за первый час суток (00-01) 13-06-2009
  - *awstats0620091301.debianworld.ru.txt* - статистика за второй час суток (01-02) 13-06-2009
  - и т.д.
  - *awstats06200913.debianworld.ru.txt* - статистика за сутки 13-06-2009

Чтобы статистика генерировалась с заданным уровнем детализации на регулярной основе, необходимо вписать соответствующее значение параметра **DatabaseBreak** в файл расписания cron. Должно получиться приблизительно так:

``` bash
    $ more /etc/cron.d/awstats
    0 2 * * * www-data [ -x /usr/lib/cgi-bin/awstats.pl \
                                   -a -f /etc/awstats/awstats.debianworld.ru.conf \
                                   -a -r /var/www/debianworld.ru/logs/apache_access.log ] && \
                                 /usr/lib/cgi-bin/awstats.pl -config=debianworld.ru -update -DatabaseBreak=day >/dev/null
```
Просмотр ежедневной статистики AWstats
======================================
После того, как статистика с необходимым уровнем детализации сгенеррована, необходимо как-то просмотреть результаты. В предыдущей [статье про установку awstats](http://debianworld.ru/articles/ustanovka-i-nastrojka-awstats-v-debian-lenny-50/ "Установка и настройка AWStats"), просмотр статистики был доступен по адресу:

    http://debianworld.ru/cgi-bin/awstats.pl

Теперь же, необходимо использовать дополнительные параметры. Например, чтобы **посмотреть статистику за какой-то час суток** (первый час суток 13-06-2009), необходимо обратитсья по адресу:

    http://debianworld.ru/cgi-bin/awstats.pl?databasebreak=hour&hour=01&day=13&month=06&year=2009

Если же необходимо посмотреть статистику за какой-то день, то необходимо обратиться по адресу:

    http://debianworld.ru/cgi-bin/awstats.pl?databasebreak=day&day=13&month=06&year=2009

Вот и все. Как и говорилось в самом начале статьи, из неудобств лишь отсутствие удобного меню навигации по статистике за день, сутки, месяц, год. В остальном - вполне приемлимо для использования.
