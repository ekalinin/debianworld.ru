layout: post
title: Установка и настройка Munin в Debian / Ubuntu — Настройка клиента, управление плагинами
date: 2009-05-23
tags:
- debian
- ubuntu
- debian-lenny
- munin
- мониторинг
categories: articles
permalink: ustanovka-i-nastrojka-munin-v-debian-ubuntu-2

---

Продолжаем тему, начатую в [Установка и настройка Munin в Debian / Ubuntu](/articles/ustanovka-i-nastrojka-munin-v-debian-ubuntu)

<!-- more -->

Настройка Munin клиента
-----------------------

Если необходимо выполнять **мониторинг производительности** нескольких машин, то необходимо установить пакет **munin-node** на каждой машине, за состоянием которой надо следить.

После установки, в директории **/etc/munin** будет создана следующая структура файлов:

``` bash
    # файл конфигурации munin клиента
    ./munin-node.conf
    # директория настроек плагинов munin клиента
    ./plugin-conf.d/
    # директория, в которой каждый файл - символическафя ссылка на плагин из /usr/share/munin/plugins
    ./plugins/
```
Открываем файл конфигурации Munin клиента:

``` bash
    $ sudo vim /etc/munin/munin-node.conf
```
Выглядеть он должен приблизительно следующим образом:

``` bash
    # ...
    log_level 4
    log_file /var/log/munin/munin-node.log
    pid_file /var/run/munin/munin-node.pid

    background 1
    setseid 1

    user root
    group root
    setsid yes

    # Regexps for files to ignore
    ignore_file ~$
    ignore_file \.bak$
    ignore_file %$
    ignore_file \.dpkg-(tmp|new|old|dist)$
    ignore_file \.rpm(save|new)$
    ignore_file \.pod$

    # Set this if the client doesn't report the correct hostname when
    # telnetting to localhost, port 4949
    #
    #host_name localhost.localdomain

    # A list of addresses that are allowed to connect.  This must be a
    # regular expression, due to brain damage in Net::Server, which
    # doesn't understand CIDR-style network notation.  You may repeat
    # the allow line as many times as you'd like

    allow ^127\.0\.0\.1$

    # Which address to bind to;
    host *
    # host 127.0.0.1

    # And which port
    port 4949
```

Здесь прежде всего будет необходимо изменить имя клиента. Заменить:

``` bash
    # Set this if the client doesn't report the correct hostname when
    # telnetting to localhost, port 4949
    #
    #host_name localhost.localdomain
```
На, например:

``` bash
    # Set this if the client doesn't report the correct hostname when
    # telnetting to localhost, port 4949
    #
    host_name DebianWorld.Ru
```
Далее, необходимо указать IP munin-сервера. Получиться должно что-то в этом роде:

``` bash
    # A list of addresses that are allowed to connect.  This must be a
    # regular expression, due to brain damage in Net::Server, which
    # doesn't understand CIDR-style network notation.  You may repeat
    # the allow line as many times as you'd like

    allow ^127\.0\.0\.1$
    allow ^192\.168\.10\.2$
```

Управление плагинами Munin
==========================

Список установленных плагинов на munin клиенте можно получить следующим образом:

``` bash
    $ ls -l /etc/munin/plugins/
    lrwxrwxrwx 1 root root 28 Май 20 22:11 cpu -> /usr/share/munin/plugins/cpu
    lrwxrwxrwx 1 root root 27 Май 20 22:11 df -> /usr/share/munin/plugins/df
    lrwxrwxrwx 1 root root 33 Май 20 22:11 df_inode -> /usr/share/munin/plugins/df_inode
    lrwxrwxrwx 1 root root 32 Май 20 22:11 entropy -> /usr/share/munin/plugins/entropy
    lrwxrwxrwx 1 root root 30 Май 20 22:11 forks -> /usr/share/munin/plugins/forks
    lrwxrwxrwx 1 root root 35 Май 20 22:11 interrupts -> /usr/share/munin/plugins/interrupts
    lrwxrwxrwx 1 root root 29 Май 20 22:11 load -> /usr/share/munin/plugins/load
    lrwxrwxrwx 1 root root 31 Май 20 22:11 memory -> /usr/share/munin/plugins/memory
    lrwxrwxrwx 1 root root 35 Май 20 22:11 open_files -> /usr/share/munin/plugins/open_files
    lrwxrwxrwx 1 root root 36 Май 20 22:11 open_inodes -> /usr/share/munin/plugins/open_inodes
    lrwxrwxrwx 1 root root 34 Май 20 22:11 processes -> /usr/share/munin/plugins/processes
    lrwxrwxrwx 1 root root 31 Май 20 22:11 vmstat -> /usr/share/munin/plugins/vmstat
```
Список доступных для установки плагинов можно посмотреть следующим образом:

``` bash
    $ ls -l /usr/share/munin/plugins/
    # ... очень много плагинов  ...
```
Установка плагина заключается в создании символьной ссылки. Например так:

``` bash
    $ sudo su
    $ cd /etc/munin/plugins/
    $ sudo ln -s /usr/share/munin/plugins/apache_processes
```
Большинство плагинов может бють запущено из командной строки. Например, так:

``` bash
    $ cd /etc/munin/plugins
    $ ./apache_processes autoconf
    no (no apache server-status on ports 80)
```
После незначительных настроек, получаем требуемый ответ:

``` bash
    $ cd /etc/munin/plugins
    $ ./apache_processes autoconf
    yes
```
После окончания настройки клиента, необходимо рестартовать Munin:

``` bash
    $ sudo /etc/init.d/munin-node restart
```
Продолжение [тут](/articles/ustanovka-i-nastrojka-munin-v-debian-ubuntu-3)
