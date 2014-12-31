layout: post
title: unoconv - конвертация Word, PDF, SWF, HTML, PPT документов в Debian / Ubuntu
date: 2009-11-23
tags:
- ubuntu
-  debian
-  unoconv
-  openoffice
-  python
categories: articles
permalink: unoconv-konvertaciya-word-pdf-swf-html-ppt-dokumentov-v-debian-ubuntu
---
**Unoconv** - скрипт, написанный на python, позволяющий **конвертировать документы** различных форматов. Скрипт зависит от офисного пакета OpenOffice. Соответственно, форматы файлов поддерживаются только те, которые OpenOffice может импортировать / экспортировать. Для преобразования документов используется интерфейс доступа к компонентной модели OpenOffice.org - Uno.
<!-- more -->
Unoconv при старте пытается запустить экземпляр ooffice на локальной машине, если такового не было обнаружено. Кроме этого, возможно выполнять конвертацию на удаленной машине, для чего необходим экземпляр OpenOffice, запущенный на удаленной машине, и принимающий соединения из вне. Начиная с OpenOffice 2.3, для запуска ooffice более не требуется оконная система (X display).

Установка unoconv
=============
Скрипт присутствует в стандартных репозиториях. Для начала необходимо установить пакеты, обеспечивающие работу OpenOffice без оконной системы:

``` bash
    $ sudo aptitude install openoffice.org-headless \
                            openoffice.org-writer \
                            openoffice.org-impress
```

Далее, ставим сам скрипт конвертации:

``` bash
    $ sudo aptitude install unoconv
```
Конвертация документов с помощью unoconv
==============================
OpenOffice работает в клиент-серверном окружении. То есть, для конвертации необходимо:

 * клиент, посылающий запросы на конвертацию документов серверу
 * сервер, который будет обрабатывать запросы на конвертацию документов и отсылающий результат конвертации обратно клиенту

Примеры взаимодействия OpenOffice севрера/клиента 
-----------------------------------------------------------------
Запуск сервера и клиента на одной машине выполняется следующим образом:

``` bash
    # запуск в фоне сервер OpenOffice
    $ unoconv --listener & 
    [1] 5867
```
    # проверка наличия процесса
    $ ps -ao args | grep soffice
    soffice.bin -nologo -nodefault -accept=socket,host=localhost,port=2002;urp;StarOffice.ComponentContext

    # конвертация презентации OpenOffice в презентацию MS Office
    $ unoconv -f ppt convert-odp-2-swf.odp


Пример удаленной работы будет такой:

``` bash
    # запуск сервера OpenOffice на удаленной машине
    admin@remote-host:~$ unoconv --listener --server 10.0.0.1 --port 777
```
    # запрос на конвертацию для удаленной машины
    dw@debianworld.ru:~$ unoconv --server 10.0.0.1 --port 777 -f swf convert-odp-2-swf.odp


Примеры конвертации презентаций (PPT, SWF, PDF, HTML)
----------------------------------------------------------------------
Примеры конвертации форматов файлов презентаций:

``` bash
    # конвертация презентации OpenOffice в презентацию MS Office
    $ unoconv -v -f ppt convert-odp-2-swf.odp
    Input file: convert-odp-2-swf.odp
    Selected output format: Microsoft PowerPoint 97/2000/XP [.ppt]
    Selected ooffice filter: MS PowerPoint 97
    Used doctype: presentation
    Output file: convert-odp-2-swf.ppt
```
    # конвертация презентации MS Office в flash ролик
    $ unoconv -v -f swf convert-odp-2-swf.ppt
    Input file: convert-odp-2-swf.ppt
    Selected output format: Macromedia Flash (SWF) [.swf]
    Selected ooffice filter: impress_flash_Export
    Used doctype: presentation
    Output file: convert-odp-2-swf.swf

    # конвертация презентации MS Office в HTML
    $ unoconv -v -f html convert-odp-2-swf.ppt
    Input file: convert-odp-2-swf.ppt
    Selected output format: HTML Document (OpenOffice.org Impress) [.html]
    Selected ooffice filter: impress_html_Export
    Used doctype: presentation
    Output file: convert-odp-2-swf.html

    # конвертация презентации MS Office в PDF
    $ unoconv -v -f pdf convert-odp-2-swf.ppt
    Input file: convert-odp-2-swf.ppt
    Selected output format: Portable Document Format [.pdf]
    Selected ooffice filter: impress_pdf_Export
    Used doctype: presentation
    Output file: convert-odp-2-swf.pdf

Примеры конвертации документов (Word, PDF, RTF, HTML, Text)
----------------------------------------------------------------------

``` bash
    # конвертация документа OpenOffice в PDF
    $ unoconv -v -f pdf convert-doc.odt
    Input file: convert-doc.odt
    Selected output format: Portable Document Format [.pdf]
    Selected ooffice filter: writer_pdf_Export
    Used doctype: document
    Output file: convert-doc.pdf
```
    # конвертация документа OpenOffice в RTF
    $ unoconv -v -f rtf convert-doc.odt
    Input file: convert-doc.odt
    Selected output format: Rich Text Format [.rtf]
    Selected ooffice filter: Rich Text Format
    Used doctype: document
    Output file: convert-doc.rtf

    # конвертация документа OpenOffice в HTML
    $ unoconv -v -f html convert-doc.odt
    Input file: convert-doc.odt
    Selected output format: HTML Document (OpenOffice.org Writer) [.html]
    Selected ooffice filter: HTML (StarWriter)
    Used doctype: document
    Output file: convert-doc.html

    # конвертация документа OpenOffice в текст
    $ unoconv -v -f txt convert-doc.odt
    Input file: convert-doc.odt
    Selected output format: Plain Text [.txt]
    Selected ooffice filter: Text
    Used doctype: document
    Output file: convert-doc.txt

Весь приведенный код конвертации для большей читабельности использует ключ "-v" для вывода отладочной информации. Естественно, что при отсутствии необходимости диагностических сообщений этот ключ можно опустить.