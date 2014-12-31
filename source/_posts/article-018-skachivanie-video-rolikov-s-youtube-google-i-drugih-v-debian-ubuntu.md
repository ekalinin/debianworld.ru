layout: post
title: Скачивание видео роликов с Youtube в Debian / Ubuntu
date: 2009-06-01
tags:
- debian
- ubuntu
- clive
- utils
categories: articles
permalink: skachivanie-video-rolikov-s-youtube-google-i-drugih-v-debian-ubuntu

---

**Clive** - консольная утилита, позволяющая **скачивать видео ролики** с таких видео хостингов, как YouTube, Google Video и другие. Поддерживает извлечение встроенного видео и может использоваться  вместе с внешним кодеком (например: ffmpeg) для **перекодирования скаченного видеоролика** в отличный видео формат (например: avi, mpeg, flv).

<!-- more -->

Характеристики Clive
====================

Поддерживает **скачивание видео роликов** со следующих видео хостингов:

  - youtube.com 
  - video.google.(com|au|ca|de|es|fr|it|nl|pl|uk|cn)
  - dailymotion.com
  - guba.com
  - metacafe.com
  - last.fm
  - sevenload.com
  - break.com

Технические характеристики:

  - поддержка batch-режима (скачивание пачки роликов по очереди)
  - совместим с UNIX-pipe
  - интеграция с X clipboard (xclip)
  - возможно использование сторонних проигрывателей
  - возможно перекодирование в различные видео форматы (с помощью ffmpeg)
  - поддержка прокси (как опция, так и через переменную окружения http_proxy)
  - выбор качества изображения скачиваемого ролика (если поддерживает видео хостинг, например youtube.com)
  - кэширование URL
  - скачивание видео роликов через RSS/Atom ленты
  - переопределение имени скачиваемого ролика
  - докачка (если поддерживает видео хостинг)
  - использование логина и пароля для youtube

Установка Clive
===============

Установка тривиальна:

``` bash
    $ sudo aptitude install clive
```
Настройка Clive
===============

Рекомендуется использовать файл конфигурации, если предполагается использование утилит ffmpeg, xine, xclip и прочих. Чтобы создать файл конфигурации, необходимо выполнить:

``` bash
    $ clive --write-conf
```
После чего будет создан файл конфигурации: **~/.clive/config**. 

Примеры использования Clive
===========================

Чтобы **скачать видео ролик с Youtube**, необходимо выполнить:

``` bash
    $ clive http://youtube.com/watch?v=dr3qPRAAnOg
```
Чтобы **скачать несколько видео роликов с Youtube**, необходимо выполнить:

``` bash
    $ cat url.lst
    http://youtube.com/watch?v=dr3qPRAAnOg
    http://youtube.com/watch?v=VlFGTtU65Xo
    $ cat url.lst | clive
    # либо так:
    $ clive < url.lst
    # либо так:
    $ clive "http://youtube.com/watch?v=dr3qPRAAnOg" "http://youtube.com/watch?v=VlFGTtU65Xo"
```
Чтобы **скачать видео ролик с Youtube и проиграть его**, необходимо выполнить:

``` bash
    $ clive --player="/usr/bin/xine %i" --play=src http://youtube.com/watch?v=dr3qPRAAnOg
```
Чтобы **скачать видео ролик с Youtube, перекодировать и проиграть его**, необходимо выполнить:

``` bash
    $ clive --ffmpeg="/usr/bin/ffmpeg -y -i %i %o" \
               --player="/usr/bin/xine %i" --play=mpg \
               http://youtube.com/watch?v=dr3qPRAAnOg
```
Чтобы **скачать видео ролик с Youtube, используя ленту RSS**, необходимо выполнить:

``` bash
    $ clive --rss http://youtube.com/rss/user/clipcritics/videos.rss
```
Чтобы **просмотреть кэш ссылок на видео ролики**, необходимо выполнить:

``` bash
    $ clive --cache
```
Чтобы вставить ссылку на видео ролик из X clipboard (-x) , просканировать (-S) ссылки на наличие видео роликов, скачать ролик в низком качестве (-L) и отключить кэширование ссылок (-C), необходимо выполнить:

``` bash
    $ clive -xSLC
```
