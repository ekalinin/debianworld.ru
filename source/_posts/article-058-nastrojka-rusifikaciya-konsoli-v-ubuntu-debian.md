layout: post
title: Настройка (русификация) консоли в Ubuntu / Debian
date: 2010-02-20
tags:
- debian
-  ubuntu
-  русификация-консоли
-  консоль
categories: articles
permalink: nastrojka-rusifikaciya-konsoli-v-ubuntu-debian
---
Как правило, после того, как выполнена **установка Ubuntu или Debian** (свежего или не очень ;), необходимо сделать хоть и минимальную, но настройку. И не так уж и редки случаи, когда первостепенной задачей становится настройка вывода русского языка в консоли.
<!-- more -->
Что такое локаль/локализация
--------------------------------------
Для начала немного теории:

  * **Локализация** (localization, или сокращенно l10n) - это процесс перевода интерфейса программного обеспечения под конкретные национальные требования. 

  * **Локаль** (locale) - это файл, содержащий таблицу с указанием того, какие символы считать буквами, и как их следует сортировать. Операционная система использует эту таблицу для отображения букв определенного национального алфавита.

Настройка локали 
----------------------
В первую очередь, необходимо убедиться, какие локали доступны в системе, для этого выполняем следующую команду:

``` bash
    $ locale -a
    C
    en_US.utf8
    POSIX
```
В приведенном примере отсутствует строка "ru_RU.UTF-8", а для вывода русского языка эта локаль жизненно необходима. Если бы это строки была в списке, что можно пропустить этап установки и генерации новых локалей.

Чтобы установить новую локаль, необходимо выполнить:

``` bash
    $ sudo dpkg-reconfigure locales
```
Следует выбрать, как минимум:

    ru_RU.UTF-8

И выбрать ее в качестве локали по умолчанию. После чего все необходимые локали будут сгенерированы и можно будет приступать непосредственно к русификации консоли.

Настройка (русификация) консоли
--------------------------------------------
Первым делом, необходимо проверить, какая установлена локаль в системе:

``` bash
    $ locale
    LANG=
    LC_CTYPE="POSIX"
    LC_NUMERIC="POSIX"
    LC_TIME="POSIX"
    LC_COLLATE="POSIX"
    LC_MONETARY="POSIX"
    LC_MESSAGES="POSIX"
    LC_PAPER="POSIX"
    LC_NAME="POSIX"
    LC_ADDRESS="POSIX"
    LC_TELEPHONE="POSIX"
    LC_MEASUREMENT="POSIX"
    LC_IDENTIFICATION="POSIX"
    LC_ALL=
```
Представленный вывод - явный признак того, что необходимо настроить локаль. 

Для этого, необходимо установить пакет console-cyrillic:

``` bash
    $ sudo aptitude install console-cyrillic
```
При этом будут заданы несколько вопросов, ответить на которые необходимо приблизительно следующим образом:

    What virtual consoles do you use?                           -->  /dev/tty[1-6]
    Choose the keyboard layout                                  -->  Russian
    Toggling between Cyrillic and Latin characters              -->  Caps Lock
    Switching temporarily between Cyrillic and Latin characters -->  No temporary switch
    Choose a font for the console.                              -->  UniCyr
    What is your favourite font size?                           -->  14
    What is your encoding?                                      -->  UNICODE
    Do you want to setup Cyrillic on the console at boot-time?  -->  Yes


Если после установки появится необходимость в перенастройке, то для этих целей необходимо выполнить:

``` bash
    sudo dpkg-reconfigure console-cyrillic
```
После того, как все настройки сделаны, необходимо перезагрузить систему, либо выполнить:

``` bash
    sudo /etc/init.d/console-cyrillic start 
```
Убедиться в корректности настройки локали можно следующим образом:

``` bash
    $ locale
    LANG=ru_RU.UTF-8
    LC_CTYPE="ru_RU.UTF-8"
    LC_NUMERIC="ru_RU.UTF-8"
    LC_TIME="ru_RU.UTF-8"
    LC_COLLATE="ru_RU.UTF-8"
    LC_MONETARY="ru_RU.UTF-8"
    LC_MESSAGES="ru_RU.UTF-8"
    LC_PAPER="ru_RU.UTF-8"
    LC_NAME="ru_RU.UTF-8"
    LC_ADDRESS="ru_RU.UTF-8"
    LC_TELEPHONE="ru_RU.UTF-8"
    LC_MEASUREMENT="ru_RU.UTF-8"
    LC_IDENTIFICATION="ru_RU.UTF-8"
    LC_ALL=
```
Все выставленные настройки русификации хранятся в файле:

     /etc/console-cyrillic