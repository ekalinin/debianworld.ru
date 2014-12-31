layout: post
title: Установка Oracle XE (Express Edition) в Debian / Ubuntu - 2
date: 2009-05-27
tags:
- debian
- ubuntu
- oracle
- oracle-xe
categories: articles
permalink: ustanovka-oracle-xe-express-edition-v-debian-ubuntu-2

---

Продолжаем тему, начатую в [Установка Oracle XE (Express Edition) в Debian / Ubuntu](/articles/ustanovka-oracle-xe-express-edition-v-debian-ubuntu) 

<!-- more -->

Подсказки для Oracle Express Edition
====================================

Текущие настройки Oracle Express Edition всегда можно просмотреть/отредактировать в файле **/etc/default/oracle-xe**.

Включение/выключение Oracle XE службы
-------------------------------------

Есть как минимум 2 способа это сделать:

  - Сделать не исполняемым скрипт запуска службы:

``` bash
$ sudo chmod -x /etc/init.d/oracle-xe 
```
  - Изменить соответствующую настройку в /etc/default/oracle-xe:

``` bash
    #ORACLE_DBENABLED=true
    ORACLE_DBENABLED=false
```

Управление удаленными sql-соединениями
--------------------------------------

По-умолчанию, Oracle XE не позволяет устанавливать удаленных sql-соединения к базе данных с машин, отличных от той, где выполнялась установка. Для того, чтобы их разрешить, необходимо войти в web-консоль управления СУБД (http://127.0.0.1:8080/apex) и включить "Remote connections": 

    "Administration" -> включить "Available from local server and remote clients"-> нажать "Apply Changes"

Тот же эффект будет достигнут с помощью следующей команды:

``` bash
    $ sqlplus -S system/password@//localhost/XE <<!
    EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE); 
    EXIT;
    /
    !
```
Создание удаленных sql-соединений
---------------------------------

При условии, что удаленной машине [установлен Oracle Instant Client](http://debianworld.ru/articles/ustanovka-oracle-instant-client-v-debian-ubuntu/ "Пример установки Oracle Instant Client в Debian / Ubuntu##index##") или oracle-xe-client, с нее можно устанавливать соединения к Oracle XE:

``` bash
    $ sqlplus username/password@//oraclexe.hostname.or.ip//XE
```

Если Oracle XE отказывает в соединении (например, работает FireWall и т.д.), то можно пробросить ssh-туннель на свою машину и работать в условиях, как если бы Oracle XE был установлен на локальной машине (при этом ssh-клиент на машине, откуда устанавливается соединение, должен позволять это. Необходимо убедиться, что в конфиге ssh присутствует *AllowTcpForwarding yes*):

``` bash
    # Пробрасываем туннель для sqlplus
    $ ssh oracle-xe-server -L 1512:localhost:1512
    # Пробрасываем туннель для apex
    $ ssh oracle-xe-server -L 8081:localhost:8080
```
После этого, войти в web-консоль управления управления СУБД можно по адресу: http://localhost:8081/apex, а установить sql-соединение так:

``` bash
    $ sqlplus username/password@//localhost//XE
```
