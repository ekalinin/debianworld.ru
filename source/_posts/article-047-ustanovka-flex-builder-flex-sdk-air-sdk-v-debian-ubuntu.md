layout: post
title: Установка Flex Builder | Flex SDK | AIR SDK в Debian / Ubuntu 
date: 2009-09-28
tags:
- ubuntu
-  debian
-  flex
categories: articles
permalink: ustanovka-flex-builder-flex-sdk-air-sdk-v-debian-ubuntu
---
**Adobe Flex** - технология для быстрого создания RIA-приложений (**Rich Internet Applications**). Flex базируется на:

  * **MXML** - язык на основе XML, используемый для описания формата пользовательского интерфейса и поведения
  * **ActionScript 3** - объектно-ориентированный язык программирования, используемый для создания логической модели поведения

Flex приложение может быть скомпилировано как "на лету" (то есть, на сервере), таки и из IDE (начиная с Flex 2). Результатом компиляции является swf файл, исполняемый с помощью **Flash Player**.
<!-- more -->
Обзор компонентов Flex
================
Для создания Flex-приложений понадобятся следующие компоненты:
  
  * **Eclipse** - свободная среда разработки, реализованная на Java. Позволяет значительно расширять функционал за счет подключений плагинов.
  * **Adobe Flex SDK** - набор классов для разработки Flex-приложений
  * **Adobe AIR SDK** - набор классов и утилит для разработки AIR-приложений
  * **Adobe Flex Builder** - средство разработки, основанное на Eclipse, позволяющее разрабатывать Flex/RIA приложения.

Установка Java
===========
Одним из самых главных требований для Flex является наличие в системе установленной Sun JRE 1.5.x (или более новой версии). Для установки Java необходимо выполнить:

``` bash
    $ sudo aptitude install sun-java6-jre
```
Подготовка к установке Flex
===================
Далее всё ПО будет устанавливаться не из репозиториев. Поэтому, чтобы разделить директории с исходными архивами и директории, куда будет выполняться установка, создадим следующую структуру:

``` bash
    $ mkdir ~/soft
    $ mkdir ~/eclipse-3.5
```
Загрузка и установка Eclipse
===================
Следующим этапом необходимо [скачать Eclipse IDE](http://eclipse.org/downloads/ "Страница для скачивания eclipseе") и установить её (Рекомендуется Eclipse Classic). При наличии прямого линка можно скачивать так:

``` bash
    $ wget http://ftp.rnl.ist.utl.pt/pub/eclipse/eclipse/downloads/drops/R-3.5.1-200909170800/eclipse-SDK-3.5.1-linux-gtk.tar.gz
```
Далее, распаковывем архив и переносим его в соответствующую директорию:

``` bash
    $ tar xzvf eclipse-SDK-3.5.1-linux-gtk.tar.gz
    $ mv eclipse ~/eclipse-3.5
```
Загрузка и установка Flex Builder For Linux
============================
Следующим шагом, необходимо скачать [Flex Builder alpha 4 For Linux](http://labs.adobe.com/downloads/flexbuilder_linux.html "Страница для скачивания Flex Builder alpha 4 For Linux"). В консоли необходимо выполнить следующую команду:

``` bash
    $  wget http://download.macromedia.com/pub/labs/flex/flexbuilder_linux/flexbuilder_linux_install_a4_081408.bin
```
Далее, необходимо запустить программу **установки Flex Builder For Linux**:

``` bash
    $ chmod a+x flexbuilder_linux_install_a4_081408.bin
    $ ./flexbuilder_linux_install_a4_081408.bin
```
В ходе установки, в следующих экранах необходимо указать соответствующие пути:

  * "Choose Install folder":        "~/eclipse-3.5/Adobe_Flex_Builder"
  * "Choose Eclipse Folder":       "~/eclipse-3.5/eclipse"

После экрана "Choose Eclipse Folder" появится сообщение "**Eclipse 3.3 (or higher) not found**", где необходимо нажать "**Proceed with Caution**" и дождаться окончания установки.

Наложение патча для работы Eclipse 3.5 (Galileo) и Flex Builder for Linux
================================================
К сожалению, Eclipse 3.5 (Galileo) "из коробки" работать с Flex Builder for Linux не будет. В настоящее время с Flex Builder for Linux стабильно работает только [Eclipse 3.3 (Europa)](http://archive.eclipse.org/eclipse/downloads/index.php "Страница для скачивания разных версий Eclipse"). Чтобы Eclipse 3.5 (Galileo) заработал, необходимо скачать и применить следующий патч:

``` bash
    $ wget http://blog.danyul.id.au/wp-content/uploads/2009/06/eclipse-galileo-fbl-patchtar.gz
```
Применение патча:

``` bash
    $ mv eclipse-galileo-fbl-patchtar.gz eclipse-galileo-fbl-patch.tar.gz
    $ tar xzvf eclipse-galileo-fbl-patch.tar.gz
    $ cp -v -R eclipse-galileo-fbl-patch/eclipse/plugins/* ~/eclipse-3.5/Adobe_Flex_Builder/eclipse/plugins/
```
Если до применения патча Eclipse запускался, то его надо запустить следующим образом:

``` bash
    $ ./eclipse-3.5/eclipse/eclipse -clean
```
Загрузка и установка Flex SDK
=====================
В составе **Flex Builder alpha 4** идет Flex SDK 3.0. Но в настоящее время доступна более новая версия SDK - 3.4 (и даже 4.0, но она пока находится в стадии Beta). Таким образом, следующим этапом необходимо [скачать свежий Flex SDK](http://opensource.adobe.com/wiki/display/flexsdk/Download+Flex+3 "Страница для скачивания Flex SDK") установить его. В консоли необходимо выполнить следующую команду:

``` bash
    $ wget http://fpdownload.adobe.com/pub/flex/sdk/builds/flex3/flex_sdk_3.4.1.10084.zip
```
Далее, необходимо распаковать архив в директорию, куда был установлен Flex Builder:

``` bash
    $ unzip flex_sdk_3.4.1.10084.zip -d ~/eclipse-3.5/Adobe_Flex_Builder/sdks/3.4.1.10084/
```
Загрузка и установка AIR SDK
=====================
Следующим шагом следует обновить Adobe AIR SDK, для чего необходимо [скачать AIR SDK](http://www.adobe.com/products/air/tools/sdk/ "Страница для скачивания Adobe AIR SDK") установить его. В консоли необходимо выполнить следующую команду:

``` bash
    $ wget http://airdownload.adobe.com/air/lin/download/latest/air_1.5_sdk.tbz2
```
Далее, необходимо распаковать архив в директорию, куда была установлена свежая версия Flex SDK:

``` bash
    $ tar xjvf air_1.5_sdk.tar.bz2 -C ~/eclipse-3.5/Adobe_Flex_Builder/sdks/3.4.1.10084/
```
В конце установки, необходимо скорректировать название утилит:

``` bash
    $ cd ~/eclipse-3.5/Adobe_Flex_Builder/sdks/3.4.1.10084/bin
    $ mv adl adl_lin
    $ mv adt adt_lin
```
Настройка новой SDK в Eclipse
=====================
В конце, надо прописать в настройках Eclipse новую SDK - 3.4.1.10084 (по умолчанию стоит 3.0.0). Для этого необходимо запустить Eclipse:

``` bash
    $ ./eclipse-3.5/eclipse/eclipse
```
Перейти в меню: **Window -> Preferences -> Flex -> Installed Flex SDKs**. Добавить пункт (кнопка "Add") "~/eclipse-3.5/Adobe_Flex_Builder/sdks/3.4.1.10084/" и отметить напротив добавленного пункта чекбокс.