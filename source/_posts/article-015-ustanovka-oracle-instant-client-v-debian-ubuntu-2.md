layout: post
title: Установка Oracle Instant Client в Debian / Ubuntu - 2
date: 2009-05-26
tags:
- oracle
- oracle-instant-client
- oracle-client
- debian
- ubuntu
categories: articles
permalink: ustanovka-oracle-instant-client-v-debian-ubuntu-2

---

Продолжаем тему, начатую в [Установка Oracle Instant Client в Debian / Ubuntu](/articles/ustanovka-oracle-instant-client-v-debian-ubuntu)

<!-- more -->

Установка Oracle Instant Client вручную
---------------------------------------

Допустим, необходмио установить Oracle Instant Client на Debian / Ubuntu архитектуры amd64. Для этого необходимо скачать следующие архивы на [странице, посвященной архитектуре amd64](http://www.oracle.com/technology/software/tech/oci/instantclient/htdocs/linux-amd64.html "Раздел сайта Oracle, где можно скачать Oracle Instant Client для amd64 архитектуры"):

  - instantclient-basic-linuxAMD64-10.1.0.5.0-20060519.zip
  - instantclient-sqlplus-linuxAMD64-32-10.1.0.5.0-20060519.zip
  - instantclient-sdk-linuxAMD64-32-10.1.0.5.0-20060519.zip

Далее, создаем директорию, куда будем выполнять установку:

``` bash
    $ sudo mkdir -p /usr/lib/oracle/10.1.0.5/client/lib
```
Следующим шагом распаковываем туда содержимое скачанных архивов:

``` bash
    # Распаковываем архивы
    $ unzip instantclient-basic-linuxAMD64-10.1.0.5.0-20060519.zip
    $ unzip instantclient-basic-lisqlplus-linuxAMD64-10.1.0.5.0-20060519.zip
    $ unzip instantclient-sdk-linuxAMD64-10.1.0.5.0-20060519.zip

    # Переносим все распакованное в установочную директорию
    $ sudo mv instantclient10_1/* /usr/lib/oracle/10.1.0.5/client/lib

    # Содержание установочной директории
    $ ls -l /usr/lib/oracle/10.1.0.5/client/lib/
    -r--r--r-- 1 root root  1442415 Дек  7  2005 classes12.jar
    -r--r--r-- 1 root root     1353 Дек  7  2005 glogin.sql
    -rwxr-xr-x 1 root root 15306239 Дек  7  2005 libclntsh.so.10.1
    -rwxr-xr-x 1 root root  1773518 Дек  7  2005 libnnz10.so
    -rwxr-xr-x 1 root root   958670 Дек  7  2005 libocci.so.10.1
    -rwxr-xr-x 1 root root 66423996 Дек  7  2005 libociei.so
    -rwxr-xr-x 1 root root   122861 Дек  7  2005 libocijdbc10.so
    -rwxr-xr-x 1 root root   814479 Дек  7  2005 libsqlplus.so
    -r--r--r-- 1 root root  1378315 Дек  7  2005 ojdbc14.jar
    -r--r--r-- 1 root root    22334 Дек  7  2005 README_IC.htm
    drwxr-xr-x 4 root root     4096 Дек  7  2005 sdk
    -rwxr-xr-x 1 root root    14114 Дек  7  2005 sqlplus
```

Выполняем базовые настройки:

``` bash
    $ sudo su

    # Добавляем файл конфигурации
    $ touch /etc/ld.so.conf.d/ora-inst-cl-10.1.0.5.conf

    # Пишем в него путь к только что установленному клиенту
    $ echo "/usr/lib/oracle/10.1.0.5/client/lib" > /etc/ld.so.conf.d/ora-inst-cl-10.1.0.5.conf

    # обновляем кэша динамических библиотек
    $ sudo ldconfig
```


Настройки переменных окружения для Oracle Instant Client
========================================================

Для пользовтаеля, которому необходимо пользоваться Oracle Instant Client, необходимо выполнить следующее:

``` bash
    $ echo "# oracle env" >> ~/.bashrc
    $ echo "export ORACLE_BASE=/usr/lib/oracle" >> ~/.bashrc
    # для Oracle Instant Client, установленного для x86 из rpm
    $ echo "export ORACLE_HOME=$ORACLE_BASE/11.1/client/lib" >> ~/.bashrc
    # для Oracle Instant Client, установленного для amd64 из zip архива
    $ echo "export ORACLE_HOME=$ORACLE_BASE/10.1.0.5/client/lib" >> ~/.bashrc
    $ echo "export LD_LIBRARY_PATH=$ORACLE_HOME" >> ~/.bashrc
    $ echo "export NLS_LANG=RUSSIAN_RUSSIA.UTF8" >> ~/.bashrc
    $ echo "export PATH=${PATH}:$ORACLE_HOME" >> ~/.bashrc
```
Проверяем соединение из SQL\*Plus без необходимости настраивать TNSNAMES.ORA:

``` bash
    $ sqlplus username/password@host:port/service_name
    SQL*Plus: Release 10.2.0.3.0 - Production on Пт Май 22 10:04:24 2009
    Copyright (c) 1982, 2006, Oracle.  All Rights Reserved.


    Присоединен к:
    Oracle Database 10g Enterprise Edition Release 10.2.0.4.0 - 64bit Production
    With the Partitioning, OLAP, Data Mining and Real Application Testing options

    SQL>
```
