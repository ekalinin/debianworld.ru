layout: post
title: Установка Skype в Debian / Ubuntu
date: 2009-09-11
tags:
- debian
-  skype
-  ubuntu
-  instant-messaging
categories: articles
permalink: ustanovka-skype-v-debian-ubuntu
---
**Skype** - бесплатный клиент с закрытыми исходными кодами, позволяющий выполнять **голосовые звонки через интернет** (**VoIP**). Предоставляет следующие возможности:

  * организация конференц-связи
  * передача текстовых сообщений и файлов
  * видеосвязь
<!-- more -->
Установка Skype
============
Первым делом необходимо прописать новый репозиторий, из которого будет установлен Skype:

``` bash
    $ sudo su
    $ echo "deb http://download.skype.com/linux/repos/debian/ stable non-free" >> /etc/apt/sources.list
```
После этого необходимо обновить список ПО, доступного в репозиториях:

``` bash
    $ sudo aptitude install update
```
После этого можно приступать к **установке skype**:

    ##bash##
    $ sudo aptitude install skype