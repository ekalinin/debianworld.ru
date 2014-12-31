layout: post
title: Подключаем backports в Debian Lenny (5.0)
date: 2009-05-18
tags:
- debian-lenny
- backports
- обновление
categories: articles
permalink: podklyuchaem-backports-v-debian-lenny-50

---

Использование стабильной (stable) ветки Debian гарантирует, что состав программного обеспечения будет стабилен, хорошо протестирован и количество ошибок сведено к минимуму. Но зачастую возникает ситуация, когда некоторый пакет имеется в ветках testing и unstable, однако его нет в stable, либо пакет есть в stable, но его версия сильно устарела. В этих случаях на помощь приходит концепция **Debian backports (бэкпорты)**.

<!-- more -->

Что такое Debian backports
==========================

**Debian backports** - это ветка перекомпилированных пакетов из тестовой (testing) или нестабильной (unstable) веток. В основном пакеты портируются из тестовой (testing) ветки, но бывают случаи портирования и из нестабильной (unstable) ветки: как правило, связаны с безопасностью системы. Собираются пакеты таким образом, чтобы они были работоспособными в стабильной (stable) ветке без наличия в системе каких-либо новых библиотек.

Рекомендуется устанавливать из бэкпортов только те пакеты, которые необходимы, а не всю ветку целиком.

Подключение Debian backports
============================

В настоящее время стабильной веткой является Debian Lenny 5.0, поэтому все ниже следующие примеры будет приведены относительно этой версии Debian.

Добавляем новый источник пакетов:

``` bash
    $ sudo su
    $ echo "deb http://www.backports.org/debian lenny-backports main contrib non-free" >> /etc/apt/sources.list
```
Обновляем список доступных пакетов:

``` bash
    $ sudo aptitude update
```
Устанавливаем ключи для проверки пакетов, устанавливаемых из Debian backports:

``` bash
    $ sudo aptitude install debian-backports-keyring
```
Либо:

``` bash
    $ wget -O - http://backports.org/debian/archive.key | apt-key add -
```
Либо:

``` bash
    $ sudo gpg --keyserver hkp://subkeys.pgp.net --recv-keys 16BA136C
    $ sudo gpg --export 16BA136C | apt-key add -
```

Установка пакета из Debian backports
====================================

Установка пакета из Debian backports с указанием  ветки
-------------------------------------------------------

Установка пакета, используя *apt-get*:

```bash
    $ sudo apt-get -t lenny-backports install "package"
```
Установка пакета, используя *aptitude*:

```bash
    $ sudo aptitude -t lenny-backports install "package"
```
Установка пакета из Debian backports, используя Apt-Pinning
-----------------------------------------------------------

Чтбоы каждый раз не указывать при уставновке пакета, из какой ветки его брать, можно использовать механиз закрепления / прикалывания (Apt-Pinning). С помощью этого механизма для каждого пакета можно указать ветку, откуда его необходимо устанавливать.

Для этого в файл '/etc/apt/preferences' необходимо добавить текст следующего формата:

    Package: <название-пакета>
    Pin: <версия-пакета или ветка>
    Pin-Priority: <приоритет>

Например, для пакета mutt будет:

    Package: mutt
    Pin: release a=lenny-backports
    Pin-Priority: 999

Теперь установка пакеты будет выглядеть гораздо привычнее:

``` bash
    $ sudo aptitude install “package”
```
Если же необходимо, чтобы пакеты, установленные из бэкпортов (backports), обновлялись автоматически, необходимо вписать следующие строки в '/etc/apt/preferences':

    Package: *
    Pin: release a=lenny-backports
    Pin-Priority: 200
