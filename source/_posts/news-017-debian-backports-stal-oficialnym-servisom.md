layout: post
title: Debian Backports стал официальным сервисом
date: 2010-09-06
category: news
permalink: debian-backports-stal-oficialnym-servisom

---

**Debian Backports** - это сервис, предоставляющий возможность установки в стабильной версии Debian пакетов из тестируемых (testing) или нестабильных (unstable) версий Debian. До недавнего времени, этот ресурс был независимым от основного ресурса Debian, и располагался на отдельном домене - **backports.org**.
<!-- more -->
Теперь же, сервис будет доступен так же и по адресу **backports.debian.org**. И хотя старые ссылки будут доступны еще некоторое время, всем пользователям настоятельно рекомендуется скорректировать имеющиеся настройки источников в apt (/etc/apt/sources.list) на новый адрес и впредь [настраивать debian backports](http://debianworld.ru/articles/podklyuchaem-backports-v-debian-lenny-50/ "Настройка Backports для Debian Lenny (5.0)") исключительно с новым адресом:

    ##bash##
    deb http://backports.debian.org/debian-backports lenny-backports main contrib non-free

Сервис по-прежнему использует свои ключи (keyring), но в ближайшее время ожидается добавление поддержки Debian Maintainers (DM). 
