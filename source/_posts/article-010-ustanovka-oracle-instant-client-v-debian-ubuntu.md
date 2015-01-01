layout: post
title: Установка Oracle Instant Client в Debian / Ubuntu
date: 2009-05-25
tags:
- oracle
- oracle-instant-client
- oracle-client
- debian
- ubuntu
categories: articles
permalink: ustanovka-oracle-instant-client-v-debian-ubuntu

---

**Oracle Instant Client** - набор утилит и библиотек от **Oracle**, позволяющий запускать приложения, работающие с СУБД Oracle, без необходимости установки стандартного клиента. OCI, OCCI, Pro\*C, ODBC, и JDBC приложения будут работать без каких-либо изменений не зависимо от того: установлен ли **стандартный Oracle Client** или **Oracle Instant Client**. Но при работе с последним будет использоваться значительно меньше места на жестком диске. **SQL*Plus** так же будет работать с **Oracle Instant Client** без каких-либо изменений или перекомпиляций.

**Oracle Instant Client** абсолютно бесплатен, доступен для множества платформ и архитектур, среди которых Mac OS X, Solaris, HP-UX, Linux и т.д.

<!-- more -->

[Официальная страница проекта Oracle Instant Client](http://www.oracle.com/technology/tech/oci/instantclient/index.html "Официальная страница Oracle Instant Client") расположена на соответствующем разделе сайта Oracle.

Описание Oracle Instant Client
==============================

**Oracle Instant Client** используется главным образом для того, чтобы поставляться вместе с приложениями, которым необходимо работать с СУБД Oracle. То есть, разработчики программного обеспечения помимо своего приложения включают в дистрибутив Oracle Instant Client, чтобы избавить конечного пользователя от необходимости самостоятельной установки и настройки какого-либо клиента Oracle.

**Основные преимущества Oracle Instant Client** перед стандартным клиентом Oracle:

  - Установка заключается в копировании небольшого числа файлов
  - Объем занимаемого места на жестком диске значительно ниже
  - Нет никаких потерь в производительности или функциональности
  - Простота использования и распространения сторонними разработчиками

**Oracle Instant Client состоит** из несколько пакетов:

  - **Basic**. Все, что необходимо для запуска OCI, OCCI, JDBC-OCI приложений. (*Обязательный*)
  - **Basic Lite**. Облегченная версия Basic. Сообщения об ошибках только на английском языке. Поддерживаются только Unicode, ASCII и Western European кодировки. (*Обязательный*)
  - **JDBC Supplement**. Дополнительнаяя поддержка XA, интернационализации и RowSet-операций для JDBC.
  - **SQL*Plus**. Дополнительные библиотеки и приложение для запуска SQL*Plus.
  - **ODBC Supplement**. Дополнительные библиотеки для работы ODBC-приложений (не для всех платформ)
  - **SDK**. Дополнительные заголовочные файлы и примеры  мейкфайлов (makefile) для разработки Oracle-приложений с Instant Client.
  - **ODAC**. Включает ODP.NET, Oracle Services для MTS, Oracle Providers для ASP.NET, Oracle Provider для OLE DB и OO4O.

Установка Oracle Instant Client в Debian \ Ubuntu
=================================================

Всё необходимое для установки Oracle Instant Client можно скачать на соответствующем [разделе сайта Oracle](http://www.oracle.com/technology/software/tech/oci/instantclient/index.html "Раздел сайта Oracle, где можно скачать Oracle Instant Client для различных архитектур и платформ"). В силу того, что все пакеты поставляются в двух видах: zip-архив и rpm-архив, установку можно проводить двумя способами: с помощью пакетного менеджера для rpm-архива или вручную для zip-архива.

Установка Oracle Instant Client с помощью пакетного менеджера и alien
---------------------------------------------------------------------

Допустим, необходмио установить Oracle Instant Client на Debian / Ubuntu архитектуры x86. Для этого необходимо скачать следующие архивы на [странице, посвященной архитектуре x86](http://www.oracle.com/technology/software/tech/oci/instantclient/htdocs/linuxsoft.html "Раздел сайта Oracle, где можно скачать Oracle Instant Client для x86 архитектуры"):

  - oracle-instantclient11.1-basic-11.1.0.7.0-1.i386.rpm
  - oracle-instantclient11.1-devel-11.1.0.7.0-1.i386.rpm
  - oracle-instantclient11.1-sqlplus-11.1.0.7.0-1.i386.rpm

Устанавливаем утлититу преобразования rpm архивов в deb:

``` bash
    $ sudo aptitude install alien
```
Преобразовываем скачанные rpm архивы в deb и устанавливаем их:

``` bash
    $ sudo alien -i oracle-instantclient11.1-basic-11.1.0.7.0-1.i386.rpm
    $ sudo alien -i oracle-instantclient11.1-sqlplus-11.1.0.7.0-1.i386.rpm
    $ sudo alien -i oracle-instantclient11.1-devel-11.1.0.7.0-1.i386.rpm
```
Выполняем базовые настройки:

``` bash
    $ sudo su

    # Добавляем файл конфигурации
    $ touch /etc/ld.so.conf.d/ora-inst-cl-11.1.0.7.conf

    # Пишем в него путь к только что установленному клиенту
    $ echo "/usr/lib/oracle/11.1/client/lib" > /etc/ld.so.conf.d/ora-inst-cl-11.1.0.7.conf

    # обновляем кэша динамических библиотек
    # и делаем библиотеки видимыми для системы
    $ sudo ldconfig
```
