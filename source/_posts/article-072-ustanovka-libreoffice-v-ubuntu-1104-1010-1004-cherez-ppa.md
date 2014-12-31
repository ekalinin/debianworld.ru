layout: post
title: Установка LibreOffice в Ubuntu 11.04 / 10.10 / 10.04 через PPA
date: 2011-01-29
tags:
- ubuntu
-  libreoffice
-  openoffice
categories: articles
permalink: ustanovka-libreoffice-v-ubuntu-1104-1010-1004-cherez-ppa
---
**LibreOffice** - офисный пакет, являющийся форком проекта OpenOffice.org. 
Пакет появился после того, как компания Oracle приобрела Sun Microsystems, 
и мнения по поводу будущего развития проекта разошлись между новым владельцем 
и независимыми разработчиками. 

Совсем недавно соcтоялся [релиз](http://listarchives.documentfoundation.org/www/announce/msg00026.html 
"Анонс релиза LibreOffice 3.3") офисного пакета [LibreOffice](http://www.libreoffice.org/ 
"Сайт проекта LibreOffice") 3.3. [Ожидается](https://lists.ubuntu.com/archives/ubuntu-devel/2011-January/032298.html
"Анонс замены OpenOffice пакетом LibreOffice начиная с Ubuntu 11.04 / Natty Narwha"), 
что в следующей версии Ubuntu пакет LibreOffice заменит OpenOffice.

<!-- more -->

Удаление OpenOffice.org
-----------------------

Перед установкой LibreOffice необходимо удалить (если он установлен) пакет 
OpenOffice.Org. Сделать это, можно используя следующую команду:

``` bash
    $ sudo apt-get purge openoffice*.*
```

Установка LibreOffice
---------------------

Установка пакет будет выполняться через PPA, что гарантирует своевременное 
наличие обновлений и легкость их установки. Сейчас в PPA есть пакеты для 
Ubuntu 10.04 / 10.11 / 11.04. 

Первым делом, необходимо добавить новый источник пакетов:

``` bash
    $ sudo add-apt-repository ppa:libreoffice/ppa
```
Далее идет непосредственно сама установка пакета:

``` bash
    $ sudo apt-get update
    $ sudo apt-get install libreoffice
```
Если для вас важен русский интерфейс и справка, то необходимо установить так 
же следующие пакеты:

``` bash
    $ sudo apt-get install libreoffice-l10n-ru 
    $ sudo apt-get install libreoffice-help-ru
```
Для пользователей Gnome, рекомендуется поставить следующий пакет:

``` bash
    $ sudo apt-get install libreoffice-gnome
```
Для пользователей KDE, рекомендуется аналогичный пакет:

``` bash
    $ sudo apt-get install libreoffice-kde
```
Готово. Новый пакет можно искать в Приложения (Applications) --> 
Офис (Office).
