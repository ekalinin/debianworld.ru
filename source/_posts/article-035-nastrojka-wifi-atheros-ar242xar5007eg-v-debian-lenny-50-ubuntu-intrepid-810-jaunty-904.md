layout: post
title: Настройка Wifi Atheros AR242x(AR5007EG) в Debian Lenny (5.0) / Ubuntu intrepid (8.10), jaunty (9.04) 
date: 2009-07-06
tags:
- debian-lenny
-  ubuntu-intrepid
-  ubuntu-jaunty
-  atheros
-  wifi
categories: articles
permalink: nastrojka-wifi-atheros-ar242xar5007eg-v-debian-lenny-50-ubuntu-intrepid-810-jaunty-904
---
У обладателей таких ноутбуков, как: **Asus X51RL, Fujitsu-Siemens s6420, Toshiba a201, Samsung NC10, Amilo Mini 3520, Acer Aspire 5315** и еще многих других, есть одна общая проблема - **Wifi карточка Atheros AR5007EG / AR242x**, работоспособность которой после установки Linux-системы, как правило, оставляет желать лучшего. Благодаря проекту [madwifi](http://madwifi-project.org/ "Проект по разработки драйверов для Wifi карт на основе Atheros чипсетов"), **установка драйверов Atheros** не доставляет много проблем.
<!-- more -->
Диагностика оборудования: наличие Atheros AR5007EG /AR242x
===========================================
В первую очередь необходимо убедиться, что в системе действительно установлена Wifi карта Atheros AR5007EG /AR242x:

``` bash
    $ lspci | grep Atheros
    18:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
```
Установка пакетов для сборки драйверов для Atheros AR5007EG /AR242x
=================================================
Следующим шагом, необходимо установить пакеты для успешной компиляции драйвера:

``` bash
    $ sudo aptitude update 
    $ sudo aptitude install build-essential linux-headers-$(uname -r)
```
Установка MadWifi драйверов для для Atheros AR5007EG /AR242x
============================================
Далее, необходимо скачать драйвер для Atheros AR5007EG /AR242x:

``` bash
    $ mkdir ./mad-wifi
    $ cd ./mad-wifi
    $ wget http://snapshots.madwifi-project.org/madwifi-hal-0.10.5.6/madwifi-hal-0.10.5.6-r4103-20100110.tar.gz
```
После того, как драйвер скачан, его необходимо разархивировать и скомпилировать:

``` bash
    # Разархивируем драйвер
    $ tar zxvf madwifi-hal-0.10.5.6-r4103-20100110.tar.gz
    $ cd madwifi-hal-0.10.5.6-r4103-20100110
```
    # Компилируем драйвер
    $ make
    $ sudo make install

Теперь драйвер скомпилирован. Необходимо проверить работу wifi-карты с новым драйвером:

``` bash
    # включаем модуль ядра
    $ sudo modprobe ath_pci
```
    # включаем wifi-интерфейс
    $ sudo ifconfig ath0 up

    # проверяем настройки wifi
    $ iwconfig
    lo        no wireless extensions.
    
    eth0      no wireless extensions.
    
    wifi0     no wireless extensions.
    
    ath0      IEEE 802.11g  ESSID:"XXXXXXXXXXXXX"  Nickname:""
              Mode:Managed  Frequency:2.437 GHz  Access Point: XX:XX:XX:XX:XX:XX
              Bit Rate:6 Mb/s   Tx-Power:17 dBm   Sensitivity=1/1
              Retry:off   RTS thr:off   Fragment thr:off
              Power Management:off
              Link Quality=21/70  Signal level=-74 dBm  Noise level=-95 dBm
              Rx invalid nwid:848  Rx invalid crypt:0  Rx invalid frag:0
              Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Если вывод последней команды похож на приведенный, то можно констатировать, что wifi карта работает. Остается лишь включить модуль ядра в загрузку и перезагрузиться:

``` bash
    $ sudo su
    $ echo "ath_pci" >> /etc/modules
```
    # блокируем загрузку альтернативного драйвера
    $ echo "blacklist ath5k" >> /etc/modprobe.d/blacklist

    # перезагрузка
    $ reboot

Единственным недостатком такого метода является необходимость пересобирать драйвер после каждого обновления ядра. Благо, теперь это просто.

Удаление MadWifi драйверов для для Atheros AR5007EG /AR242x
============================================
В случае, если что-либо не получилось, либо появилось желание установить более свежий драйвер, то текущую установку можно без труда удалить:

    ##bash##
    $ cd ./mad-wifi/madwifi-hal-0.10.5.6-r4103-20100110
    $ sudo make uninstall