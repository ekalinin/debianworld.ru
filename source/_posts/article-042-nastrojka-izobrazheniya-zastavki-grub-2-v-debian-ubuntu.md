layout: post
title: Настройка изображения заставки GRUB 2 в Debian / Ubuntu
date: 2009-09-07
tags:
- debian
- grub-2
- ubuntu
categories: articles
permalink: nastrojka-izobrazheniya-zastavki-grub-2-v-debian-ubuntu

---

**GRUB 2** - это  это новый загрузчик, написанный с нуля. Кроме всего прочего он позволяет легко настраивать внешний вид: изображение для экрана заставки и шрифты.

<!-- more -->

Установка изображений для заставки GRUB 2
=========================================
GRUB 2  предлагает небольшой набор изображений, которые можно установить на заставку. Для их появления в системе, необходимо установить пакет grub2-splashimages:

``` bash
    $ sudo aptitude install grub2-splashimages
```
Все установленные изображения должны появиться в директории ``/usr/share/images/grub``. Приблизительно должен быть следующий список:

``` bash
    $ ls -l /usr/share/images/grub
    total 14032
    -rw-r--r-- 1 root root 814353 2008-02-05 12:42 050817-N-3488C-028.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 2006-02-15_Piping.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 Aesculus_hippocastanum_fruit.tga
    -rw-r--r-- 1 root root 866898 2008-02-05 12:42 Apollo_17_The_Last_Moon_Shot_Edit1.tga
    -rw-r--r-- 1 root root 816018 2008-02-05 12:42 B-1B_over_the_pacific_ocean.tga
    -rw-r--r-- 1 root root 800658 2008-02-05 12:42 BonsaiTridentMaple.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 Flower_jtca001.tga
    -rw-r--r-- 1 root root 817938 2008-02-05 12:42 Fly-Angel.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 Glasses_800_edit.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 Hortensia-1.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 Lake_mapourika_NZ.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 Moraine_Lake_17092005.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 Plasma-lamp.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 Sparkler.tga
    -rw-r--r-- 1 root root 921618 2008-02-05 12:42 TulipStair_QueensHouse_Greenwich.tga
    -rw-r--r-- 1 root root 920214 2008-02-05 12:42 Windbuchencom.tga
```
Установка изображения в качестве заставки GRUB 2
================================================
Настройка заставки для GRUB 2 находится в файле ``/etc/grub.d/05_debian_theme``. Его необходимо открыть в любимом редакторе:

``` bash
    $ sudo vim /etc/grub.d/05_debian_theme
```
И отредактировать следующим образом (для примера будем устанавливать на заставку изображение Sparkler.tga):

``` bash
    # ...
        # Было:
        #for i in {/boot/grub,/usr/share/images/desktop-base}/moreblue-orbit-grub.{png,tga} ; do
        # Стало:
        for i in {/boot/grub,/usr/share/images/desktop-base,/usr/share/images/grub}/Sparkler.{png,tga} ; do
    # ...
```
Далее, необходимо обновить конфигурацию GRUB 2:

``` bash
    $ sudo update-grub
    Updating /boot/grub/grub.cfg ...
    Found Debian background: Sparkler.tga
    Found linux image: /boot/vmlinuz-2.6.26-2-686
    Found initrd image: /boot/initrd.img-2.6.26-2-686
    done
```
И наконец, перезагрузиться:

``` bash
    $ sudo reboot
```
Создание изображений для заставки GRUB 2
========================================
Создание собственного изображения для заставки GRUB 2 не составляет большого труда. Для этого необходимо:

  * открыть любой графический файл в **GIMP** (Gnu Image Manipulation Program)
  * изменить размеры изображения до 640x480
  * сохранить как .tga файл

После этого полученный файл можно использовать в качестве заставке для GRUB 2.

Настройка цвета для шрифтов в GRUB 2
====================================
После того, как установлено необходимое изображение в качестве заставки для GRUB 2, как правило, следует выбрать подходящие цвета для шрифта. настройки выполняются в том же файле "/etc/grub.d/05_debian_theme". Кусок кода, отвечающий за настройку шрифтов при установленной картинке в качестве заставки выглядит следующим образом:

``` bash
    #...
    # set the background if possible
    if ${use_bg} ; then
      prepare_grub_to_access_device `${grub_probe} --target=device ${bg}`
      cat << EOF
    insmod ${reader}
    if background_image `make_system_path_relative_to_its_root ${bg}` ; then
      set color_normal=black/black
      set color_highlight=magenta/black
    else
    EOF
    fi
    #...
```
Непосредственная настройка цвета происходит в строчках "set color_normal ..." и "set color_highlight ...". Допускается использование следующих названий цветов:

  * black (читай - прозрачный), white,
  * dark-gray, light-gray,
  * brown, yellow,
  * red, light-red,
  * blue, light-blue,
  * green, light-green,
  * cyan, light-cyan,
  * magenta, light-magenta.

Формат команды выставления цвета достаточно прост:

  * set color_normal=цвет_текста/цвет_фона. Выставляет цвет основного текста меню GRUB 2.
  * set color_highlight=цвет_текста/цвет_фона. Выставляет цвет текста и фона выбранной строчки меню GRUB 2.

Например, код может выглядеть следующим образом:

``` bash
    #...
    # set the background if possible
    if ${use_bg} ; then
      prepare_grub_to_access_device `${grub_probe} --target=device ${bg}`
      cat << EOF
    insmod ${reader}
    if background_image `make_system_path_relative_to_its_root ${bg}` ; then
      set color_normal=white/black
      set color_highlight=black/white
    else
    EOF
    fi
    #...
```
После внесения изменений, необходимо их сохранить:

``` bash
    $ sudo update-grub
    Updating /boot/grub/grub.cfg ...
    Found Debian background: Sparkler.tga
    Found linux image: /boot/vmlinuz-2.6.26-2-686
    Found initrd image: /boot/initrd.img-2.6.26-2-686
    done
```
И перезагрузиться:

``` bash
    $ sudo reboot
```
Чтобы сохранить немного времени при подборе цвета меню и не перезагружаться каждый раз при выборе нового цветового решения, можно в меню GRUB 2 на лету изменять цвета шрифтов. Для этого необходимо нажать 'c' находясь в меню и использовать команды "set color_normal ..." / "set color_highlight ... ". После выполнения команды "set ..." нажатием клавиши "escape" можно вернуться в главное меню GRUB 2 и просмотреть, как оно выглядит.
