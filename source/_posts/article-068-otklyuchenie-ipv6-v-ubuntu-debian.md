layout: post
title: Отключение ipv6 в Ubuntu / Debian
date: 2010-03-30
tags:
- debian
-  ubuntu
-  ipv6
categories: articles
permalink: otklyuchenie-ipv6-v-ubuntu-debian
---
**IPv6** - это новая версия протокола IP, отличающаяся от предыдущей версии (**IPv4**) длиной адреса в 128 бит (вместо 32 бит в IPv4). В настоящее время использование IPv6 в интернете постепенно набирает обороты, но пока ещё не получило столь широкого распространения , как IPv4. Поэтому, зачастую, в использовании этого протокола просто нет необходимости, ибо не только бесполезно, но и тратит ценные системные ресурсы. 
<!-- more -->

Включен ли IPv6?
----------------------
Чтобы проверить, используется ли IPv6, достаточно взглянуть на вывод ipconfig:

``` bash
    $ sudo ifconfig | grep inet6
```
Если вышеуказанная команда ничего не вывела на экран, то у Вас IPv6 не используется и дальше можно уже не читать.

Еще один вариант (более системный) - проверить значение:

``` bash
    $ cat /proc/sys/net/ipv6/conf/all/disable_ipv6
```
Если получено значение 1, то опять же - дальнейшее чтиво не обязательно.

Отключение IPv6
---------------------
В первую очередь, необходимо отредактировать файл /etc/modprobe.d/aliases:

``` bash
    $ sudo vim /etc/modprobe.d/aliases
```
И привести его, к следующему виду:

``` bash
    alias net-pf-10 ipv6 off
    alias net-pf-10 off
    alias ipv6 off
```
Если в файле присутствует строка "alias net-pf-10 ipv6", то ее необходимо закомментировать.

Далее, отключаем IPv6 в ядре:

``` bash
    $ echo 1 | sudo tee /proc/sys/net/ipv6/conf/all/disable_ipv6
```
А так же,  добавляем строчку эту операции в автозагрузку. Скрипт **/etc/rc.local** должен выглядеть приблизительно следующим образом:

``` bash
    $ tail /etc/rc.local 
    #....
    echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
    #
    # By default this script does nothing.
    exit 0
```
Далее, блокируем загрузку соответствующего модуля: 

``` bash
    $ echo "blacklist ipv6" | sudo tee -a /etc/modprobe.d/blacklist
    # в зависимости от версии, может быть и так:
    # echo "blacklist ipv6" | sudo tee -a /etc/modprobe.d/blacklist.conf
```
И наконец, прописываем в grub опцию, отключающую загрузку IPv6 ():

``` bash
    $ sudo vim /boot/grub/menu.lst
```
Если, допустим, конфигурация загрузки у Вас выглядит так:

``` bash
    title           Ubuntu 9.10, kernel 2.6.31-20-generic
    uuid            08b70bd0-5a61-4f9c-a8b8-464c5beb48e2
    kernel         /boot/vmlinuz-2.6.31-20-generic root=UUID=08b70bd0-5a61-4f9c-a8b8-464c5beb48e2 ro nohotplug quiet splash
    initrd          /boot/initrd.img-2.6.31-20-generic
    quiet
```
то после редактирования конфигурация grub должна выглядеть так:

``` bash
    title           Ubuntu 9.10, kernel 2.6.31-20-generic
    uuid            08b70bd0-5a61-4f9c-a8b8-464c5beb48e2
    kernel          /boot/vmlinuz-2.6.31-20-generic root=UUID=08b70bd0-5a61-4f9c-a8b8-464c5beb48e2 ro nohotplug quiet splash ipv6.disable=1
    initrd          /boot/initrd.img-2.6.31-20-generic
    quiet
```
Все. Теперь необходимо перезагрузить компьютер.  И убедиться, что нет никаких сетевых соединений, использующих IPv6:

    ##bash##
    $ sudo netstat -npl | grep -E "tcp6|udp6" | wc -l
    0
