layout: post
title: Установка VirtualBox в Debian Lenny (5.0)
date: 2009-05-15
tags:
- debian-lenny
- virtualbox
categories: articles
permalink: ustanovka-virtualbox-v-debian-lenny-50

---

**VirtualBox** является  платформой для виртуализации (или просто: **виртуальная машина**) операционных систем (**Windows**, **Linux**, **Mac OS** и т.д.). Является кроссплатформенной системой, поддерживает виртуализацию как 32-битных, так и 64-битных систем. В последних версиях **VirtualBox** появилась поддержка образов жестких дисков VMDK (VMware) и VHD (Microsoft Virtual PC). Так же  **VirtualBox** предоставляем возможность работы со снимками стсемы (snapshots), поддерживаем различные виды сетевого взаимодействия (NAT, Host Networking via Bridged, Internal) и позволяет создавать папки совместного доступа(shared folders) для простого обмена файлами между хостовой и гостевой системами.

<!-- more -->

Установка VirtualBox
====================

Добавляем новый источник пакетов:

``` bash
    $ sudo su
    $ echo "deb http://download.virtualbox.org/virtualbox/debian lenny non-free" >> /etc/apt/sources.list
```
Импортируем PGP ключи:

``` bash
    $ wget -q http://download.virtualbox.org/virtualbox/debian/sun_vbox.asc -O- | apt-key add -
```
Обновляем список доступного програмного обеспечения и устанавливаем пакет **VirtualBox**:

``` bash
    $ sudo aptitude update
    $ sudo aptitude install virtualbox-2.1
```
Первый запуск и минимальная настройка VirtualBox
================================================

Запускаем **VirtualBox**:

``` bash
    $ VirtualBox
```
Если при запуске появляется ошибка:

    The VirtualBox kernel driver is not accessible to the current user. 
    Make sure that the user has write permissions for /dev/vboxdrv by adding them to the vboxusers groups. 
    You will need to logout for the change to take effect.
    VBox status code: -1909 (VERR_VM_DRIVER_NOT_ACCESSIBLE).

То пугаться не стоит. Необходимо всего лишь добавить текущего пользователя в группу vboxusers:

``` bash
    $ sudo adduser `whoami` vboxusers
```
