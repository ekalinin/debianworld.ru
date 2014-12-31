layout: post
title: Мониторинг Tornado с помощью Munin в Debian / Ubuntu
date: 2010-03-17
tags:
- debian
-  munin
-  nginx
-  ubuntu
-  мониторинг
-  tornado
categories: articles
permalink: monitoring-tornado-s-pomoshyu-munin-v-debian-ubuntu
---
Такие слова, как [Tornado](http://debianworld.ru/articles/tag/tornado/ "Статьи на тему веб-сервера Tornado") или [Munin](http://debianworld.ru/articles/tag/munin/ "Статьи на тему системы мониторинга Munin"), уже не должны быть незнакомыми для читателей DebainWorld.Ru. И необходимость в мониторинге ресурсов системы - тоже не новость. Ниже будет представлен вариант решения задачи мониторинга состояния **веб-сервера Tornado**.
<!-- more -->
Ниже следующее изложение предполагает, что материалы о:

  * [запуске Tornado и Django под Nginx](http://debianworld.ru/articles/ustanovka-i-nastrojka-django-nginx-cherez-tornado-v-debian-ubuntu/ "Установка и настройка Django через Tornado под Nginx").
  * [добавлении плагинов контроля состояния Nginx для Munin](http://debianworld.ru/articles/monitoring-nginx-s-pomoshyu-munin-v-debian-ubuntu/ "Мониторинг nginx с помощью Munin")

уже прочитаны и усвоены. А так же  считаем, что Munin и Tornado уже настроены и работают. 

Для решения задачи осталось не много - добавить **плагин для munin** и убедиться, что он работает.

Суть мониторинга Tornado
-------------------------------
Согласно материалу о [запуске Tornado под Nginx](http://debianworld.ru/articles/ustanovka-i-nastrojka-django-nginx-cherez-tornado-v-debian-ubuntu/ "Установка Django,Tornado,Nginx") tornado запускается следующим образом:

``` bash
    $ python deploy/tornading.py 8001 &
    $ python deploy/tornading.py 8002 &
```
Соответственно, чтобы узнать размер памяти, занимаемой этими двумя процессам, необходимо воспользоваться следующим кодом:

``` bash
    $ ps aux | grep tornading | grep -v grep
    dw        9321  0.4  0.7  21184 15384 ?        S    10:29   0:14 python deploy/tornading.py 8001
    dw        9324  0.4  0.8  22280 16584 ?        S    10:29   0:13 python deploy/tornading.py 8002
```
Этот код и будет сутью нашего плагина. Весь вывод представлен в килобайтах. Нас интересует:

  * шестая по счету колонка из представленного вывода, что есть ничто иное, как RSS - размер постоянно занимаемой физической памяти
  * пятая  по счету колонка из представленного вывода, что есть VSZ - размер виртуальной памяти, занимаемой процессом

Плагин мониторинга Tornado для Munin
-----------------------------------------------
Создаем плагин:

``` bash
    $ sudo vim /usr/share/munin/plugins/tornado_memory
```
Пишем следующее:

``` bash
    #!/usr/bin/env perl
```
    if ( exists $ARGV[0] and $ARGV[0] eq "config" ) {
        print "graph_title Tornado ram usage\n";
        print "graph_vlabel ram\n";
        print "graph_vlabel vmem\n";
        print "graph_category tornado\n";
        print "ram.label ram\n";
        print "vmem.label vmem\n";
                print "graph_args --base 1024\n";
    } else {
        my $i=0, $vm=0;
        @cmd = `ps aux | grep tornading | grep -v grep | grep -v tornado_memory`;

        foreach (@cmd) {
            @return = split(/ +/, $_);
            $i += @return[5]*1024;
            $vm += @return[4]*1024;
        }
        print "ram.value ".$i."\n";
        print "vmem.value ".$vm."\n";
    }


Суть плагина проста - получаем информацию о состоянии необходимых процессов и суммируем необходимые значения. Все суммы переводим в мегабайты.

Остается включить плагин:

``` bash
    $ sudo chmod +x /usr/share/munin/plugins/tornado_memory
    $ sudo ln -s /usr/share/munin/plugins/tornado_memory /etc/munin/plugins/tornado_memory
```
И проверить, что он работает:

``` bash
    $ sudo munin-run tornado_memory
    ram.value 32124928
    vmem.value 44199936
```
Все. Можно любоваться графиками.