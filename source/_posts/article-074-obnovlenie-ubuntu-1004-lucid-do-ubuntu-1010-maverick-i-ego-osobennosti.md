layout: post
title: Обновление Ubuntu 10.04 Lucid до Ubuntu 10.10 Maverick и его особенности
date: 2011-02-20
tags:
- ubuntu
-  обновление
-  ubuntu-lucid
-  ubuntu-maverick
categories: articles
permalink: obnovlenie-ubuntu-1004-lucid-do-ubuntu-1010-maverick-i-ego-osobennosti
---
10.10.2010 был [релиз](https://lists.ubuntu.com/archives/ubuntu-announce/2010-October/000139.html "Анонс релиза Ubuntu 10.10 Maverick Meerkat") очередной версии Ubuntu. И пришла пора обновляться. 

<!-- more -->

Обычный сценарий обновления Ubuntu
-----------------------------------------------
Следуя обычным инструкциям по [обновлению Ubuntu](http://debianworld.ru/articles/oblenie-servera-ubuntu-810-intrepid-do-ubuntu-904-jaunty/ "Обновление Ubuntu 8.10 до Ubuntu 9.04"), необходимо выполнить всего четыре пункта:

  * сделать бэкап системы (или основных ее жизненно важных каталогов: /etc, /var/lib/dpkg, и прочие)
  * установить пакет **update-manager-core**:

    ``` bash
        $ sudo aptitude update && sudo aptitude install update-manager-core
```
  * отредактировать файл **/etc/update-manager/release-upgrades** и установить в нем **Prompt=normal**
  * запустить обновление:

    ``` bash
        $ sudo do-release-upgrade
```

и далее следовать инструкциям.... но в этот раз кое-что может оказаться по-другому...

Необычный сценарий обновления Ubuntu
--------------------------------------------------
В этот раз может ожидать неожиданный "сюрприз":

``` bash
    $ sudo do-release-upgrade
    ...
    Не удалось рассчитать обновление 
    системы 
```
    An unresolvable problem occurred while calculating the upgrade: 
    E:Error, pkgProblemResolver::Resolve generated breaks, this may be 
    caused by held packages. 

    This can be caused by: 
    * Upgrading to a pre-release version of Ubuntu 
    * Running the current pre-release version of Ubuntu 
    * Unofficial software packages not provided by Ubuntu 

    Если ничего не помогает, сообщите, 
    пожалуйста, об ошибке, связанной с 
    пакетом "update-manager", и приложите файлы 
    из /var/log/dist-upgrade/ к сообщению. 

Как оказалось, проблема уже известна - [Bug #606652](http://goo.gl/bFnaR "#606652: E:Error, pkgProblemResolver::Resolve generated breaks, this may be caused by held packages."). 

Лечим ошибку "E:Error, pkgProblemResolver::Resolve generated breaks ..."
-----------------------------------------------------------------------------------------
Суть проблемы кроется в пакетех **xserver-xorg-video-all** и **xserver-xorg-video-nouveau**. Согласно логу:

``` bash
    Investigating libdrm-nouveau1
    Package libdrm-nouveau1 has broken Breaks on xserver-xorg-video-nouveau
      Considering xserver-xorg-video-nouveau 2 as a solution to libdrm-nouveau1 17
      Upgrading xserver-xorg-video-nouveau due to Breaks field in libdrm-nouveau1
    Investigating xserver-xorg-video-nouveau
    Package xserver-xorg-video-nouveau has broken Depends on xorg-video-abi-8.0
      Considering xserver-xorg-core 79 as a solution to xserver-xorg-video-nouveau 2
      Holding Back xserver-xorg-video-nouveau rather than change xorg-video-abi-8.0
    Done
 
появились не удовлетворенные зависимости для пакета xserver-xorg-video-nouveau, поэтому обновление не могло быть успешно проведено. [Исправление ошибки](http://goo.gl/ghnjB "Исправление ошибки при обновлении Ubuntu 10.04 до Ubuntu 10.10") оказалось весьма тривиально - достаточно удалить пакет xserver-xorg-video-nouveau:
```
``` bash
    $ sudo aptitude remove xserver-xorg-video-nouveau
    ...         
    Следующие пакеты С ОШИБКАМИ:
      xserver-xorg-video-all 
    Следующие пакеты будут УДАЛЕНЫ:
      xserver-xorg-video-nouveau 
    0 пакетов обновлено, 0 установлено новых, 1 пакетов отмечено для удаления, и 1630 пакетов не обновлено.
    Необходимо получить 0Б архивов. После распаковки освободится 279kБ.
    Следующие пакеты имеют неудовлетворённые зависимости:
      xserver-xorg-video-all: Зависит: xserver-xorg-video-nouveau но его невозможно установить
    Следующие действия разрешат зависимости:
```
    Удалить следующие пакеты:
    xserver-xorg-video-all

    Счёт 119

    Принять данное решение? [Y/n/q/?] Y
    ...

Все. После этого можно повторять попытку обновления:

``` bash
    $ sudo do-release-upgrade
```
С большой долей вероятности больше проблем не будет.