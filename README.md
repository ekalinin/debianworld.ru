Что это
=======

Содержимое сайта http://debianworld.ru

Как работает
============

Работает на базе http://hexo.io/

Установка
=========

Требуется node.js и установленный глобально hexo.
Например, используя [envirius](https://github.com/ekalinin/envirius):

```bash
$ nv mk dw-hexo-2.8.3 --node-prebuilt=0.10.35
$ nv on dw-hexo-2.8.3
(dw-hexo-2.8.3) $ npm install -g hexo
(dw-hexo-2.8.3) $ node -v
v0.10.35
(dw-hexo-2.8.3) $ hexo version
hexo: 2.8.3
os: Linux 3.13.0-43-generic linux ia32
http_parser: 1.0
node: 0.10.35
v8: 3.14.5.9
ares: 1.9.0-DEV
uv: 0.10.30
zlib: 1.2.8
modules: 11
openssl: 1.0.1j
```

Локальный запуск
================

```bash
$ make init
$ make dev
```

Лицензия
========

CC-BY
