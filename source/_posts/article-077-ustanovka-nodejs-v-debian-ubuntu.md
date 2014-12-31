layout: post
title: Установка Node.js в Debian / Ubuntu 
date: 2011-05-22
tags:
- node.js
-  virtualenv
-  nodeenv
categories: articles
permalink: ustanovka-nodejs-v-debian-ubuntu

---

**Node.js** - событийно-ориентированный фреймворк на JavaScript движке
от Google **V8** с неблокирующим вводом/выводом. Последнее свойство является
killer фичей и способствует созданию масштабируемых сетевых приложений
(например, веб-серверов).  Node.js по целям использования сходен с фреймворками
Twisted на языке Python и EventMachine на Ruby.

<!-- more -->

Установка Node.js из исходников
-------------------------------

Рекомендуемым способом установки является компиляция из исходных кодов. Внешних
зависимостей практически нет:

  * python 2.4 и выше (система сборки Node.js написана на python)
  * libssl-dev (необходима, если планируется использование SSL/TLS)

Итак начнем сборку. Благо, что занятие это не сильно сложное и выполняется в
несколько простых шагов:

``` bash
    # зависимости
    $ sudo apt-get install g++ curl libssl-dev
```
    # качается и распаковывается исходный код
    $ wget http://nodejs.org/dist/node-v0.4.8.tar.gz
    $ tar -xzf node-v0.4.8.tar.gz

    # сборка node.js
    $ cd node-v0.4.8/
    $ ./configure
    $ make
    $ sudo make install

Плюсы такого подхода:

  * всегда свежая версия

Минусы:

  * для обновления необходима ручная перекомпиляция


Установка Node.js из deb-репозитория
------------------------------------

В Ubuntu 10.10 и выше в репозитории уже добавлен необходимый для установки
Node.js пакет. Чтобы его установить достаточно выполнить:

``` bash
    $ sudo apt-get install nodejs
```
Плюсы такого подхода:

  * автоматическое обновление без ручной перекомпиляции

Минусы:

  * не всегда свежая версия

Если же хочется версию по-новее, то можно подключить внешний репозиторий:

``` bash
    $ sudo apt-get install python-software-properties
    $ sudo add-apt-repository ppa:jerome-etienne/neoip
    $ sudo apt-get update
    $ sudo apt-get install nodejs
```
В Debian пакет так же присутствует, но, к сожалению, пока только в unstable
ветке.

Установка Node.js в виртуальном окружении
-----------------------------------------

Чтобы немного облегчить сборку из исходников и при этом предоставить
возможность создавать изолированные окружения (очень полезно при создании
одинаковых тестовых, разработческих и продакшен сред) можно воспользоваться
утилитой [nodeenv](http://pypi.python.org/pypi/nodeenv "Утилита для создания
виртуального окружения для Node.js"). Данная утилита по функциональности
очень напоминает [virtualenv](http://pypi.python.org/pypi/virtualenv),
позволяющую настраивать окружения для python.

Итак, установка утилиты достаточно проста:

``` bash
    $ sudo apt-get install python-virtualenv
    $ sudo easy_install nodeenv
```
После чего будет доступна возможность создания виртуальных сред Node.js:

``` bash
    $ nodeenv ~/node-env
```
При этом будет скачана и установлена последняя стабильная версия Node.js.
Активировать среду достаточно просто:

    $ source ~/node-env/bin/activate

После этого можно работать с Node.js:

    (node-env) $ node -v
    v0.4.8

Выключить режим виртуальной среды можно так:

    (node-env) $ deactivate

Проверка
--------

Напишем простое hellow-node.js приложение и убедимся, что оно работает.

``` javascript
    $ cat hello-node.js
    var http = require('http');
    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello Node.js World!\n');
    }).listen(1337, "127.0.0.1");
    console.log('Server running at http://127.0.0.1:1337/');
```
    $ node hello-node.js
    Server running at http://127.0.0.1:1337/

Проверяем работоспособность:

``` bash
    $ curl http://127.0.0.1:1337/
    Hello Node.js World!
```
Работает!
