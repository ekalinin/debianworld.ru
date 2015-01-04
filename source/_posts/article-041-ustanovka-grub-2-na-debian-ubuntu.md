layout: post
title: Установка GRUB 2 на Debian / Ubuntu
date: 2009-08-31
tags:
- grub-2
- debian
- ubuntu
categories: articles
permalink: ustanovka-grub-2-na-debian-ubuntu

---

**GRUB 2** - это новый загрузчик, написанный с нуля с целью реализации модульности и переносимости. **GRUB 2** ставит перед собой следующие цели:

  * поддержка скриптового языка (циклы, условия, переменные, функции)
  * графический интерфейс
  * динамическая загрузка модулей
  * возможность портирования на различные архитектуры
  * интернационализация
  * управление памятью
  * кросс-платформенная установка, позволяющая устанавливать GRUB из различных архитектур
  * режим восстановления (satge 1.5 исключен)

<!-- more -->

Установка GRUB 2
================
Для установки необходимо выполнить следующую команду:

``` bash
    $ $ sudo aptitude install grub-pc
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    Reading extended state information
    Initializing package states... Done
    Reading task descriptions... Done
    The following NEW packages will be installed:
      grub-pc liblzo2-2{a}
    The following packages will be REMOVED:
      grub{a}
    0 packages upgraded, 2 newly installed, 1 to remove and 0 not upgraded.
    Need to get 1514kB of archives. After unpacking 3318kB will be used.
    Do you want to continue? [Y/n/?] Y
```
При этом, старый **grub** будет удален. После установке будут заданы два вопроса:


Первый вопрос:

``` bash
    GRUB upgrade scripts have detected a GRUB Legacy setup in /boot/grub.
    In order to replace the Legacy version of GRUB in your system, it is recommended
    that /boot/grub/menu.lst is adjusted to chainload GRUB 2 from your existing GRUB Legacy setup.
    This step may be automaticaly performed now.
```
    It's recommended that you accept chainloading GRUB 2 from menu.lst, and verify
    that your new GRUB 2 setup is functional for you, before you install it directly to
    your MBR (Master Boot Record).

    In either case, whenever you want GRUB 2 to be loaded directly from MBR,
    you can do so by issuing (as root) the following command:
        upgrade-from-grub-legacy

    Chainload from menu.lst?


Необходимо ответить: Yes

Следующий вопрос:

``` bash
    The following Linux command line was extracted from the `kopt' parameter in GRUB Legacy's menu.lst.
    Please verify that it is correct, and modify it if necessary.
```
    Linux command line:

Необходимо оставить пустую строку и нажать enter.

Далее, чтобы увидеть новый grub, необходимо перезагрузиться:

``` bash
    $ sudo reboot
```
После того, как появился экран загрузчика, необходимо выбрать пункт "Chainload into GRUB", после чего появится приглашение от свежеустановленного **grub 2**, где уже можно выбрать ядро для загрузки и загрузить систему.


После того, как появилось уверенность в том, что GRUB 2 корректно установлен и работает, необходимо зафиксировать переход на новый grub. Для этого необходимо выполнить:

``` bash
    $ sudo upgrade-from-grub-legacy

    Installing GRUB to Master Boot Record of your first hard drive ...

    Installation finished. No error reported.
    This is the contents of the device map /boot/grub/device.map.
    Check if this is correct or not. If any of the lines is incorrect,
    fix it and re-run the script `grub-install'.

    (hd0)        /dev/sda

    GRUB Legacy has been removed, but its configuration files have been preserved,
    since this script cannot determine if they contain valuable information.  If
    you would like to remove the configuration files as well, use the following
    command:

      rm -f /boot/grub/menu.lst*

После чего необходимо еще раз перезагрузиться:
```
``` bash
    $ sudo reboot
```
Теперь при старте системы будет работать GRUB 2.

Возможные проблемы GRUB 2 в ubuntu 9.04
=======================================

Error 11: Unrecognized device string
------------------------------------
После первой перезагурки, может появится следующее сообщение:

``` bash
    Error 11: Unrecognized device string

    Press any key to continue...
```
Чтобы ее исправить необходимо:

  * нажать любую клавишу для продолжения загрузки
  * в появившемся экране выбрать "Chainload into GRUB 2"
  * нажать "e" в английской раскладке
  * выбрать пункт "root xxxxxxxxxxxxxxxxxxxx"
  * нажать "e" в английской раскладке
  * заменить "root xxxxxxxxxxxxxxxx" на "uuid xxxxxxxxxxxxxxxxxx", нажать enter
  * выбрать "uuid xxxxxxxxxxxxxxxxxxx" и нажать "b" в английской раскладке
  * выбрать ядро и нажать enter

При установке в Debian данной проблемы не замечено.
