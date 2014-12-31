layout: post
title: Установка Oracle XE (Express Edition) в Debian / Ubuntu
date: 2009-05-27
tags:
- debian
- ubuntu
- oracle
- oracle-xe
categories: articles
permalink: ustanovka-oracle-xe-express-edition-v-debian-ubuntu

---

**Oracle Express Edition (Oracle XE)** - это СУБД начального уровня, базирующаяся на основе кода Oracle Database 10g Release 2. Бесплатна для разработки, установки и распространения. **Oracle XE** легка в установке и администрировании: в комплекте идет web-интерфейс для мониторинга системы, управления пользователями, хранилищем и памятью (используется Oracle Application Express). 
Основная целевая аудитория:

  - Разработчики открытого программного обеспечения. Для использования в качестве СУБД.
  - Начинающие DBA. Для тренировки и экспериментов.
  - Независимые разработки. Для бесплатного распроранения вместе со своими продуктами.
  - Образовательные учереждения и студенты. Для образовательного процесса.

Доступна только для 32 битный платформ Linux и Windows.

<!-- more -->

Ограничения Oracle Express Edition
==================================

**Oracle XE** может быть установлена на любое количество машин с любым количеством CPU и RAM. Но при этом будут следующие ограничения, отличающие Oracle XE от старшего брата - Oracle Database 10g Release 2:

  - одна база на машину
  - ограничение размера пользовательских данных до 4GB (объем данных, занимаемый системными таблицами сюда не входит)
  - использование только 1GB RAM
  - использование только 1 CPU

Подготовка к установке Oracle Express Edition
=============================================

**Oracle XE** требует минимум 1GB памяти, поэтому если такового объема на мишине нет, то необходимо сделать свап соответствующего размера и подключить его:

``` bash
    $ sudo dd if=/dev/zero of=/swpfs1 bs=1M count=1000
    $ sudo mkswap /swpfs1
    $ sudo swapon /swpfs1
```
Установка Oracle Express Edition
================================

Добавляем новый источник пакетов:

``` bash
    $ sudo su
    $ echo "deb http://oss.oracle.com/debian unstable main non-free" >> /etc/apt/sources.list
```
Импортируем PGP ключи:

``` bash
    $ wget http://oss.oracle.com/el4/RPM-GPG-KEY-oracle -O- | sudo apt-key add - 
```
Обновляем список доступного програмного обеспечения и устанавливаем **Oracle XE**:

``` bash
    $ sudo aptitude update
    $ sudo aptitude install oracle-xe-client, oracle-xe-universal
```
Так же в репозитарии будет доступен пакет oracle-xe. Основные отличия:

  - **oracle-xe** - Только одна кодировка: однобайтовая LATIN1 (только для хранения западно-европейских языков). Интерфейс управления СУБД только на английском языке.
  - **oracle-xe-universal** - Кодировка: многобайтовый Unicode (для хранения любых языков, в т.ч. и русского). Интерфейс управления СУБД доступен на множестве основных языков (в т.ч. русский).

После установки выполняем конфигурацию Oracle TCP/IP портов и других параметров:

``` bash
    $ sudo /etc/init.d/oracle-xe configure

    Oracle Database 10g Express Edition Configuration
    -------------------------------------------------
    This will configure on-boot properties of Oracle Database 10g Express
    Edition.  The following questions will determine whether the database should
    be starting upon system boot, the ports it will use, and the passwords that
    will be used for database accounts.  Press  to accept the defaults.
    Ctrl-C will abort.

    Specify the HTTP port that will be used for Oracle Application Express [8080]: [Enter key]

    Specify a port that will be used for the database listener [1521]:[Enter key]

    Specify a password to be used for database accounts.  Note that the same
    password will be used for SYS and SYSTEM.  Oracle recommends the use of
    different passwords for each database account.  This can be done after
    initial configuration:secret
    Confirm the password:secret

    Do you want Oracle Database 10g Express Edition to be started on boot (y/n) [y]:y

    Starting Oracle Net Listener...Done
    Configuring Database...Done
    Starting Oracle Database 10g Express Edition Instance...Done
    Installation Completed Successfully.
    To access the Database Home Page go to "http://127.0.0.1:8080/apex"
```

Вот и все. Далее можно переходить в web-интерфейс  управления СУБД, находящегося по адресу http://127.0.0.1:8080/apex. Необходимо использовать логин system и введенный выше пароль.
