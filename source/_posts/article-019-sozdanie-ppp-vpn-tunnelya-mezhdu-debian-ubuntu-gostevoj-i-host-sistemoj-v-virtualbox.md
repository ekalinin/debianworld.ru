layout: post
title: Создание PPP (VPN) туннеля между Debian / Ubuntu гостевой и хост системой в VirtualBox
date: 2009-06-03
tags:
- virtualbox
- vpn
- ppp
- netcat
- ubuntu
- debian
categories: articles
permalink: sozdanie-ppp-vpn-tunnelya-mezhdu-debian-ubuntu-gostevoj-i-host-sistemoj-v-virtualbox

---

**VirtualBox** является  платформой для виртуализации (или просто: **виртуальная машина**) операционных систем (**Windows**, **Linux**, **Mac OS** и т.д.). [Установка и минимальная настройка VirtualBox](http://debianworld.ru/articles/ustanovka-virtualbox-v-debian-lenny-50/ "Установка VirtualBox в Debian / Ubuntu##index##") уже освещалась раннее.

Как правило, после установки виртуальной машина возникает необходимость в **установке соединения между гостевой и хост системой**. Для этого есть множество способов, начиная от простого использования **Shared Forleds** или проброса портов в гостевую систему и заканчивая полноценной настройкой сети, включающей создание мостов и  использование таких утилит, как **tunctl**, **brctl**, **ip** и т.д. Но есть способ гораздо проще.

Итак, допустим, что у нас есть хост машина, на которой установлен Debian, и гостевая машина, на которой установлена Ubuntu.

<!-- more -->

Установка необходимого ПО для создания PPP (VPN) туннеля в VirtualBox
=====================================================================

Устатанавливаем в гостевой и хост системах один и тот же набор утилит: **ppp** и  **netcat**.

Для этого, необходимо выполнить в хост системе:

``` bash
    user@debian-host$ sudo aptitude install ppp netcat
```
То же самое необходимо выполнить в гостевой системе:

``` bash
    user@ubuntu-guest$ sudo aptitude install ppp netcat
```
Создание PPP (VPN) туннеля между гостевой и хост системами в VirtualBox
=======================================================================

Для создания PPP (VPN) туннеля между гостевой и хост системами VirtualBox, необходимо сделать два простых действия.

Выполнить в хост системе:

``` bash
    user@debian-host$ sudo pppd noauth local lock nodefaultroute persist debug nodetach 10.1.2.3:10.4.5.6 pty "netcat -l -p 3042"
```
Незамедлительно выполнить в гостевой системе (пока только что запущенная команда в хост системе не отвалилась по timeout'у):

``` bash
    user@ubuntu-guest$ sudo pppd noauth local lock nodefaultroute persist debug nodetach passive pty "netcat 200.200.200.200 3042"
```
При этом "200.200.200.200" - это есть реальный IP-адрес хост системы.

Теперь к гостевой системе можно обращаться по адресу 10.1.2.3, а к хост системе из гостевой - по адресу 10.4.5.6. При этом доступны все UDP/TCP порты в каждой из систем.

Проверяем созданный PPP (VPN) туннель между гостевой и хост системами в VirtualBox
==================================================================================

Сначала убеждаемся, что PPP-туннель действительно создан.

Для этого смотрим на вывод ifconfig на хост системе. Он должен быть приблизительно таким:

``` bash
    user@debian-host$ sudo ifconfig | grep -A6 ppp
          ppp0      Link encap:Протокол PPP (Point-to-Point Protocol)
          inet addr:10.1.2.3  P-t-P:10.4.5.6  Mask:255.255.255.255
          ВВЕРХ POINTOPOINT RUNNING NOARP MULTICAST  MTU:1500  Metric:1
          RX packets:22284 errors:0 dropped:0 overruns:0 frame:0
          TX packets:26816 errors:0 dropped:0 overruns:0 carrier:0
          коллизии:0 txqueuelen:3
          RX bytes:9499906 (9.4 MB)  TX bytes:2668093 (2.6 MB)
```

Далее, можно проверить доступность гостевой машины.

Результат должен быть приблизительно таким:

``` bash
    user@debian-host$ ping -c 3 10.1.2.3
    PING 10.1.2.3 (10.1.2.3) 56(84) bytes of data.
    64 bytes from 10.1.2.3: icmp_seq=1 ttl=64 time=0.051 ms
    64 bytes from 10.1.2.3: icmp_seq=2 ttl=64 time=0.056 ms
    64 bytes from 10.1.2.3: icmp_seq=3 ttl=64 time=0.029 ms

    --- 10.1.2.3 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 1998ms
    rtt min/avg/max/mdev = 0.029/0.045/0.056/0.012 ms
```
И наконец, можно попытаться, например, войти в гостевую систему по SSH:

``` bash
    user@debian-host$ ssh 10.1.2.3 -l user
    user@10.1.2.3's password:
    Linux ubuntu-guest 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:57:59 UTC 2009 i686

    The programs included with the Ubuntu system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
    applicable law.

    To access official Ubuntu documentation, please visit:
    http://help.ubuntu.com/

    6 packages can be updated.
    0 updates are security updates.

    Last login: Thu Jun  1 07:20:38 2009
    user@ubuntu-guest$
```
