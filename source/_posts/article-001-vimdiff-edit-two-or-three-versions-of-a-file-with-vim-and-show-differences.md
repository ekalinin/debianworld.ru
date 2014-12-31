layout: post
title: VimDiff. Редактирование и сравнение двух или трех версий файла в Vim
date: 2009-05-08
tags:
- vim
- vimdiff
- utils
categories: articles
permalink: vimdiff-edit-two-or-three-versions-of-a-file-with-vim-and-show-differences

---

Vimdiff работает поверх Vim. Основная задача - одновременное редактирование и сравнение двух или трех файлов. Каждый сравниваемый или редактируемый файл открывается в отдельном окне. Различия между файлами подсвечиваются.

<!-- more -->

Установка vimdiff
=================

```bash
$ sudo aptitude install vim-full
```

Использование vimdiff
=====================

Синтаксис vimdiff
-----------------

Консольный вариант:

```bash
$ vimdiff [options] file1 file2 [file3]
```

GUI:

```bash
$ gvimdiff
$ vim -g
```

Показать разницу в режиме чтения:

```bash
$ viewdiff
$ gviewdiff
```

Примеры использования vimdiff
-----------------------------

Сравнение файлов:

```bash
$ vimdiff file1 file2
$ vim -d file1 file2
```

Если необходимо вертикально разбить главное окно:

```bash
$ vimdiff -O file1 file2
```

Если необходимо горизонтально разбить главное окно:

```bash
$ vimdiff -o file1 file2
```
Клавитурные сокращения в vimdiff
--------------------------------

  * **do** - Получить изменения из другого окна в текущее.
  * **dp** - Вставить изменения из текущего окна в другое.
  * **]c** - Перейти к следующему изменению.
  * **[c** - Перейти к предыдущему изменению.
  * **Ctrl W + Ctrl W** - Переключиться на другое окно.
  * **:diffupdate** - diff update
  * **:syntax off** - выключить подсветку синтаксиса
  * **zo** - раскрыть свернутый кусок текста
  * **zc** - свернуть кусок текста