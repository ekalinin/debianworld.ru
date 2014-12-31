layout: post
title: Установка Vagrant в Ubuntu 11.04
date: 2011-09-15
tags:
- vagrant
-  virtualbox
-  ubuntu
categories: articles
permalink: ustanovka-vagrant-v-ubuntu-1104

---

**Vargant** — это инструмент для создания и распространения виртуальных машин.
Построен на базе всем известного **VirtualBox**. То есть, фактически автоматизирует
процесс создания нового виртуального окружения. Позволяет заранее определить, какие пакеты
необходимо установить при создании очередной виртуальной машины.

<!-- more -->

Установка Ruby и RubyGems
--------------------------

Vagrant реализован с помощью ruby и устанавливается с помощью RubyGems.
Поэтому необходимо прежде всего установить ruby и его пакетный менеджер — RubyGems:

``` bash
    $ sudo apt-get install ruby ruby-dev rubygems
```
Далее проверим, правильно ли установлены пакеты:

``` bash
    $ ruby -v
    ruby 1.8.7 (2010-08-16 patchlevel 302) [i686-linux]
```
``` bash
    $ gem -v
    1.3.7
```
Установка VirtualBox 4.1
------------------------

Следующим щагом необходимо установить VirtualBox. В официальном репозитории находится версия 4.0.x OSE.

А для [последней версии Vagrant необходима последняя версия VirtualBox](http://vagrantup.com/docs/changes/changes_07x_08x.html
"Отличия vagrant 0.7.x от 0.8.x"), коей является версия 4.1.x.

Поэтому данный вариант не подходит:

``` bash
    $ sudo apt-get install virtualbox-ose
```
Следовательно, необходимо [установить последную версию VirtualBox](http://debianworld.ru/articles/ustanovka-virtualbox-v-debian-lenny-50/
"Установка VirtualBox в Debian"):

``` bash
    # работаем под root'ом
    $ sudo su
```
    # добавляем новый репозиторий
    $ echo "deb http://download.virtualbox.org/virtualbox/debian natty contrib" >> /etc/apt/sources.list

    # выходим из под root'a
    $ exit

Импортируем PGP ключи:

``` bash
    $ gpg --keyserver hkp://subkeys.pgp.net --recv-keys 54422A4B98AB5139
    $ gpg --export --armor 54422A4B98AB5139 | sudo apt-key add -
```
Устанавливаем VirtualBox 4.1.x:

``` bash
    $ sudo apt-get install virtualbox-4.1
```

Установка Vagrant
=================

И, наконец, сама цель данного руководства — непосредственная установка Vagrant:

``` bash
    $ sudo gem install vagrant
```
После установки пакета необходимо создать simlink в ``/usr/bin/``, чтобы пакет стал
доступным для любого пользователя системы:

``` bash
    $ sudo ln -s /var/lib/gems/1.8/gems/vagrant-0.8.6/bin/vagrant /usr/bin/vagrant
```
Проверяем, что всё работает:

``` bash
    $ vagrant --version
    [vagrant] Creating home directory since it doesn't exist: ~/.vagrant.d
    [vagrant] Creating home directory since it doesn't exist: ~/.vagrant.d/tmp
    [vagrant] Creating home directory since it doesn't exist: ~/.vagrant.d/boxes
    [vagrant] Creating home directory since it doesn't exist: ~/.vagrant.d/logs
    Vagrant version 0.8.6
```
Создание виртуальной машины в Vagrant
=====================================

После того, как Vagrant установлен, можно приступать к созданию первой виртуальной машины:

``` bash
    # Загружаем основу для виртуальной машины на базе ubuntu lucid 32 bit
    $ vagrant box add lucid32 http://files.vagrantup.com/lucid32.box
```
    # Создаем директорию для конфигурации виртуально машины
    $ mkdir ~/my-vagrant-vm && cd ~/my-vagrant-vm

    # Создаем конфигурационный файл по-умолчанию в текущем каталоге
    $ vagrant init lucid32
        create  Vagrantfile

Всё — можно запускать …

Загрузка виртуальной машины в Vagrant
=====================================

Итак, после того, как виртуальное окружение создано, необходимо его загрузить:

``` bash
    $ vagrant up
    [default] Importing base box 'lucid32'...
    [default] The guest additions on this VM do not match the install version of
    VirtualBox! This may cause things such as forwarded ports, shared
    folders, and more to not work properly. If any of those things fail on
    this machine, please update the guest additions and repackage the
    box.
```
    Guest Additions Version: 4.1.0
    VirtualBox Version: 4.1.2
    [default] Matching MAC address for NAT networking...
    [default] Clearing any previously set forwarded ports...
    [default] Forwarding ports...
    [default] -- ssh: 22 => 2222 (adapter 1)
    [default] Creating shared folders metadata...
    [default] Running any VM customizations...
    [default] Booting VM...
    [default] Waiting for VM to boot. This can take a few minutes.
    [default] VM booted and ready for use!
    [default] Mounting shared folders...
    [default] -- v-root: /vagrant

Далее проверяем вход через ssh:

``` bash
    $ vagrant ssh
    Linux lucid32 2.6.32-33-generic #70-Ubuntu SMP Thu Jul 7 21:09:46 UTC 2011 i686 GNU/Linux
    Ubuntu 10.04.3 LTS
```
    Welcome to Ubuntu!
     * Documentation:  https://help.ubuntu.com/
    Last login: Thu Jul 21 13:07:53 2011 from 10.0.2.2
    vagrant@lucid32:~$ 

Всё — можно работать в виртуальной машине!

Полезные команды Vagrant
========================

Чтобы остановить виртуальную машину, необходимо выполнить:

``` bash
    $ vagrant halt
    [default] Attempting graceful shutdown of linux...
```
Чтобы запустить машину снова, необходимо выполнить:

``` bash
    $ vagrant reload
```
Чтобы удалить виртуальную машину, необходимо выполнить:

    ##bash##
    $ vagrant destroy
