layout: post
title: Debian 6.0 "Squeeze" стал стабильным
date: 2011-02-07
category: news
permalink: debian-60-squeeze-stal-stabilnym

---

Разработчики Debian после двух лет разработки [представили новую стабильную версию Debian 6.0 / Squeeze](http://www.debian.org/News/2011/20110205a "Анонс релиза Debian 6.0 Squeeze").  В данном релизе Debian впервые представлен в двух вариантах: наряду с Debian GNU/Linux, в этой версии добавлен **Debian GNU/kFreeBSD** (ядро из проекта FreeBSD и пользовательское окружение Debian: kfreebsd-i386 / kfreebsd-amd64). 

<!-- more -->

Кроме того, новая версия примечательна тем , что дистрибутив укомплектован полностью свободным Linux-ядром. То есть ядро не содержит кода проприетарных прошивок. Последние вынесены в отдельные пакеты и перемещены в репозиторий "non-free", который по умолчанию не подключается. 


Так же  доработан и процесс загрузки системы. В **Debian 6.0** добавлена система запуска на основе зависимостей, которая обеспечивает параллельный запуск загрузочных сценариев.


Обновлено следующее основное ПО:

  * KDE 4.4.5
  * GNOME 2.30
  * Xfce 4.6
  * LXDE 0.5.0
  * X.Org 7.5
  * OpenOffice.org 3.2.1
  * GIMP 2.6.11
  * Iceweasel 3.5.16
  * Icedove 3.0.11
  * PostgreSQL 8.4.6
  * MySQL 5.1.49
  * GNU Compiler Collection 4.4.5
  * Linux 2.6.32
  * Apache 2.2.16
  * Samba 3.5.6
  * Python 2.6.6, 2.5.5 и 3.1.3
  * Perl 5.10.1
  * PHP 5.3.3
  * Asterisk 1.6.2.9
  * Nagios 3.2.3
  * Xen Hypervisor 4.0.1 (поддержка dom0, а также domU)
  * OpenJDK 6b18
  * Tomcat 6.0.18
  * и другие пакеты

Более подробную информацию о выпуске можно узнать из [документа о релизе Debian 6.0 Squeeze](http://www.debian.org/releases/squeeze/releasenotes "Подробная информация о выпуске Debian 6.0 Squeeze"). 


Скачать новые образы Debian можно через [BitTorrent](http://www.debian.org/CD/torrent-cd/ "Скачать Debian через BitTorrent") (рекомендуется), [jigdo](http://www.debian.org/CD/jigdo-cd/#which "Скачать Debian через jigdo") или [HTTP](http://www.debian.org/CD/http-ftp/ "Скачать Debian по HTTP").


Обновить версию дистрибутива с помощью apt/aptitude можно уже сейчас.
