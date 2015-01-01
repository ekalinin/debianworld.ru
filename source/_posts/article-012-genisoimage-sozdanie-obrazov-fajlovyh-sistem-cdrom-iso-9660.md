layout: post
title: Genisoimage - создание образов файловых систем CDROM (ISO-9660)
date: 2009-05-29
tags:
- genisoimage
-  iso-9660
-  iso
-  utils
categories: articles
permalink: genisoimage-sozdanie-obrazov-fajlovyh-sistem-cdrom-iso-9660

---

**GenIsoImage** - программа, предназначення для создания образов файловых систем ISO-9660 CD-ROM (или просто: iso-образ). Созданный образ впоследствии может быть записан на CD или DVD с помощью соответствующим программ (например, **wodim** или **k3b**).

**genisoimage** позволяет создавать ISO-образы следующих типов:

  - загрузочный (**El Torito**)
  - c расширениями **Rock Ridge**. Предназначены для *NIX-семейства (права доступа пользователей)
  - c расширениями **Joliet**. В основном, предназначены для Windows-семейства (unicode-имена файлов и директорий, длина одного компонента пути может быть до 64 unicode-символов)
  - с поддержкой файловой системы Macintosh HFS.

<!-- more -->

Состав пакета genisoimage
=========================

В состав пакета genisoimage входят следующие вспомогательные утилиты:

  - **mkzftree** - создает ISO-9660 образ с сжатием содержимого
  - **dirsplit** - разделяет содержимое больших директорий на диски заданного размера
  - **geteltorito** - извлекает загрузочный образ "El Torito" из образа диска

Установка genisoimage
=====================

Установка достаточно привычна для Debian / Ubuntu систем:

``` bash
    $ sudo aptitude install genisoimage
```
Использование genisoimage
=========================

Синтаксис вызова genisoimage
----------------------------

``` bash
    $ genisoimage [options] [-o filename] pathspec [pathspec ...]
```

Примеры использование genisoimage
---------------------------------

Чтобы **сделать образ диска с раширением Joliet** без ограничений на длину имени файла и вложенность директорий (-iso-level 4), в котором директория "genisoimage_examples", находящаяся в домашнем каталоге текущего пользователя, станет корневой:

``` bash
    $ genisoimage -iso-level 4 -J -o genisoimage_examples.iso ~/genisoimage_examples
```
Чтобы **сделать образ DVD-диска**, все необходимо для которого находится в директории "dvd_source" и записать на диск, необходимо выполнить:

``` bash
    $ genisoimage -dvd-video -o /some/path/to/dvd.iso ~/dvd_source
    # получить список доступных устройства для записи можно так: wodim --devices
    $ wodim -dev=/dev/scd0 /some/path/to/dvd.iso
```
Для того, чтобы **создать классический ISO-образ** (ISO9660) в файле cd.iso, в котором директория "cd_dir" станет корневой, необходимо выполнить:

``` bash
    $ genisoimage -o cd.iso cd_dir
```
Чтобы **сделать диск с раширением Rock Ridge** для исходной директории "cd_dir", необходимо выполнить:

``` bash
    $ genisoimage -o cd.iso -R cd_dir
```
Чтобы создать диск с раширением Rock Ridge для исходной директории "cd_dir", в которой все файлы имеют как минимум права на чтение и владельцем которых является root, необходимо выполнить:

``` bash
    $ genisoimage -o cd.iso -r cd_dir
```
Чтобы записать tar-архив напрямую на диск, который впоследствии будет содержать простую файловую систему ISO9660 с этим архивом, необходимо выполнить:

``` bash
    $ tar cf - . | genisoimage -stream-media-size 333000 | wodim dev=b,t,l -dao tsize=333000s -
```
Чтобы **создать HFS диск с раширениями Joliet и Rock Ridge** для исходной директории cd_dir, необходимо выполнить:

``` bash
    $ genisoimage -o cd.iso -R -J -hfs cd_dir
```
Чтобы создать HFS диск с исходной директорией cd_dir, которая содержит Netatalk Apple/Unix файлы, необходимо выполнить:

``` bash
    $ genisoimage -o cd.iso –netatalk cd_dir
```
Чтобы создать HFS диск с исходной директорией cd_dir, задавая всем файлам CREATOR и TYPE на основе их расширения файла, указанного в файле “mapping”, необходимо выполнить:

``` bash
    $ genisoimage -o cd.iso -map mapping cd_dir
```

Проверка образов, созданных genisoimage
---------------------------------------

Чтобы убедиться, в том, что образ создан именно так, как задумывалось, можно просто записать его на диск. Но можно этого и не делать, а воспользоваться утилитой **mount**:

``` bash
    # Создаем точку монтирования
    $ sudo mkdir /media/tested_iso

    # Выполняем монтирование iso-образа
    $ sudo mount -o loop -t iso9660 image.iso /media/tested_iso

    # Просматриваем содержимое образа
    $ ls -l /media/tested_iso
```
