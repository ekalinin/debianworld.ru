layout: post
title: Установка Internet Explorer с помощью IEs4Linux в Debian / Ubuntu
date: 2009-06-26
tags:
- internet-explorer
-  debian
-  ubuntu
-  utils
-  wine
-  браузер
categories: articles
permalink: ustanovka-internet-explorer-s-pomoshyu-ies4linux-v-debian-ubuntu
---
**Internet Explorer**, по очевидным причинам, отсутствует в каком-либо из **Linux** дистрибутивов, включая Debian и Ubuntu. Но иногда его наличие бывает просто необходимо, особенно это актуально для людей, связанных с разработкой в web. На помощь последним приходит приложение **IEs4Linux**.

**IEs4Linux** - это самый простой способ **установить и запустить Internet Explorer** под Linux. Установка очень проста, не требует никаких компиляций и позволяет иметь под рукой  сразу несколько версий **IE**: 5.0, 5.5, 6.0, 7.0 (пока beta)
<!-- more -->
Установка wine
==========
Для работы **Internet Explorer** необходим wine. **Wine - это реализация Windows API**, позволяющая запускать windows приложения под Linux.

Кроме wine, потребуются также библитеки для работы с графикой и с файлами Microsoft Cabinet:

``` bash
    $ sudo aptitude install wine libxxf86dga1 libxxf86vm1 cabextract
```
    # проверим версию wine
    $ wine --version
    wine-1.0.1

Установка ies4linux
=============
Для **установки ies4linux** необходимо скачать архив:

``` bash
    $ wget http://www.tatanka.com.br/ies4linux/downloads/ies4linux-latest.tar.gz
```
После чего, необходимо распаковать архив и запустить инсталятор:

``` bash
    # распаковка архива
    $ tar xzvf ies4linux-latest.tar.gz
```
    # запуск исталятора
    $ cd ies4linux-2.99.0.1/
    $ ./ies4linux

Если во время установки возникли какие-то проблемы, то можно выполнить установку без использования графического интерфейса. Например, чтобы **установить Internet Explorer 5.5, 6.0 и 7.0**, необходимо выполнить:

``` bash
    $ ./ies4linux --no-gui --beta-install-ie7 --no-desktop-icon --install-ie55
```
Все опции, необходимые для **установки IE** без графического интерфейса, описаны в помощи:

``` bash
    $ ./ies4linux --full-help
```
Запуск Internet Explorer
================
Во время установки **ies4linux** создаются необходимые скрипты в директории текущего пользователя. Чтобы посмотреть, какие версии IE были установлены, необходимо выполнить следующее:

``` bash
    $ ls  ~/bin/
    ie55  ie6  ie7
```
Таким образом, чтобы, например, **запустить Internet Explorer 6.0**, достаточно выполнить:

    ##bash##
    $ . ~/bin/ie6