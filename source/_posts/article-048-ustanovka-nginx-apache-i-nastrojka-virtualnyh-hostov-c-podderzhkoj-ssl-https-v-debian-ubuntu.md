layout: post
title: Установка Nginx, Apache и настройка виртуальных хостов c поддержкой SSL (https) в Debian / Ubuntu
date: 2009-10-05
tags:
- debian
- ubuntu
- apache
- nginx
- ssl
categories: articles
permalink: ustanovka-nginx-apache-i-nastrojka-virtualnyh-hostov-c-podderzhkoj-ssl-https-v-debian-ubuntu

---

Одна из типичных задач: установить стандартную связку Nginx + Apache и настроить два (или более) виртуальных хоста.
Виртуальные хосты привязаны к одному IP (**Name-based Virtual Host**). Кроме этого, на один из хостов необходим доступ по **https** (**SSL**).

Ранее уже описывались [преимущества совместной работы Nginx и Apache](http://debianworld.ru/articles/ustanovka-nginx-kak-front-end-k-apache-v-debian-ubuntu/ "Установка nginx фронтэндом к apache ##index##"). Там же описывались и особенности настройки этой связки. В текущем варианте будет больше внимания уделено настройке **SSL**: работой с сертификатами будет заниматься только фронтенд (nginx), бэкенд (apache) будет только отдавать контент.

<!-- more -->

Установка Nginx / Apache
========================
Устанавливаем необходимые сервера:

``` bash
    $ sudo aptitude install nginx apache2
```
При этом буду установлены так же пакеты:

  * openssl
  * openssl-blacklist
  * ssl-cert

Если этого не произошло, то необходимо установить их самостоятельно:

``` bash
    sudo aptitude install openssl openssl-blacklist ssl-cert
```
Создание сертификатов для SSL
=============================
Создание ключа
--------------
Первым делом необходимо создать приватный ключ (private key):

``` bash
    $ openssl genrsa -des3 -out debianworld.ru.key 2048
    Generating RSA private key, 2048 bit long modulus
    ............................................+++
    .....................................+++
    e is 65537 (0x10001)
    Enter pass phrase for debianworld.ru.key:
    Verifying - Enter pass phrase for debianworld.ru.key:
```
При создании ключа необходимо указать ключевую фразу (и запомнить ее).

Создание подписанного сертификата
---------------------------------
После того, как сгенерирован ключ, можно создавать самоподписанный сертификат (CSR - Certificate Signing Reques):

``` bash
    $ openssl req -new -key debianworld.ru.key -out debianworld.ru.csr
    Enter pass phrase for debianworld.ru.key:
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [AU]:RU
    State or Province Name (full name) [Some-State]:Russia
    Locality Name (eg, city) []:
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:DebianWorld.Ru
    Organizational Unit Name (eg, section) []:
    Common Name (eg, YOUR name) []:debianworld-2.ru
    Email Address []:ssl@debianworld-2.ru

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:
```

Удаление пароля из ключа
------------------------
Неприятной особенностью ключа с паролем является то, что Apache или nginx будет регулярно спрашивать пароль при старте. Очевидно, что это не очень удобно (если только кто-то не находится постоянно рядом на случай перезагрузки или аварийной остановки). Для удаления ключа из пароля необходимо выполнить следующее:

``` bash
    $ cp debianworld.ru.key debianworld.ru.key.orig

    $ openssl rsa -in debianworld.ru.key.orig -out debianworld.ru.key
    Enter pass phrase for debianworld.ru.key.orig: <пароль-который-указывался-при-создании-debianworld.ru.key>
    writing RSA key
```

Генерация SSL сертификата
-------------------------
Далее, создаем сам SSL сертификат:

``` bash
    $ openssl x509 -req -days 365 -in debianworld.ru.csr -signkey debianworld.ru.key -out debianworld.ru.crt
    Signature ok
    subject=/C=RU/ST=Russia/O=DebianWorld.Ru/CN=debianworld-2.ru/emailAddress=ssl@debianworld-2.ru
    Getting Private key
```
Теперь есть все, что необходимо для создания **SSL-соединений**.

Правильное расположение SSL сертификатов
-----------------------------------------
Заключительным шагом в создании SSL сертификата будет распределение полученных файлов в соответствующие директории.
Во-первых, копируем сам сертификат:

``` bash
    $ sudo cp debianworld.ru.crt /etc/ssl/certs/
```
Во-вторых, копируем ключ:

``` bash
    $ sudo cp debianworld.ru.key /etc/ssl/private/
```
И в-третьих, удаляем, все то, что было создано в текущей директории:

``` bash
    $ rm debianworld.ru.crt debianworld.ru.key debianworld.ru.csr debianworld.ru.key.orig
```
Настройка проксирования в Nginx
===============================
Более подробно процедура описана в статье [Установка nginx как front-end к apache в Debian / Ubuntu](http://debianworld.ru/articles/ustanovka-nginx-kak-front-end-k-apache-v-debian-ubuntu/ "Описание установки nginx/apache ##index##"). Вид конфигурационного файла должен быть следуюющим:

``` apache
    #$ cat /etc/nginx/proxy.conf
    proxy_redirect              off;
    proxy_set_header            Host $host;
    proxy_set_header            X-Real-IP $remote_addr;
    proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;
    client_max_body_size        10m;
    client_body_buffer_size     128k;
    proxy_connect_timeout       90;
    proxy_send_timeout          90;
    proxy_read_timeout          90;
    proxy_buffer_size           4k;
    proxy_buffers               4 32k;
    proxy_busy_buffers_size     64k;
    proxy_temp_file_write_size  64k;
```

Создание виртуальных хостов в Nginx
===================================
Создаем описание двух виртуальных хостов:

``` bash
    $ sudo touch /etc/nginx/sites-available/debianworld.ru-1
    $ sudo touch /etc/nginx/sites-available/debianworld.ru-2-ssl
```
Создаем необходимые директории двух виртуальных хостов:

``` bash
    $ sudo mkdir -p /home/sites/debianworld.ru-1/logs
    $ sudo mkdir -p /home/sites/debianworld.ru-1/apache
    # создаем html файл, который будет отражаться при обращении к "http://debianworld-1.ru"
    $ sudo touch /home/sites/debianworld.ru-1/apache/index.html
    $ sudo mkdir -p /home/sites/debianworld.ru-2/logs
    $ sudo mkdir -p /home/sites/debianworld.ru-2/apache
    # создаем html файл, который будет отражаться при обращении к "http(s)://debianworld-2.ru"
    $ sudo touch /home/sites/debianworld.ru-2/apache/index.html
    $ sudo chown www-data:www-data -R /home/sites/
```
Настройка стандартного виртуального хоста в Nginx
-------------------------------------------------
Файл настройки должен иметь следующий вид:

``` apache
    #$ sudo cat /etc/nginx/sites-available/debianworld.ru-1
    upstream backend {
      # Адрес back-end'a
      server 192.168.0.1:8080;
    }

    server {
        listen   80;
        server_name debianworld-1.ru;

        access_log /home/sites/debianworld.ru-1/logs/nginx_access.log;
        error_log /home/sites/debianworld.ru-1/logs/nginx_error.log;

        # Перенаправление на back-end
        location / {
            proxy_pass  http://backend;
            include     /etc/nginx/proxy.conf;
        }
        # ...
    }
```

Настройка виртуального хоста в Nginx с поддержкой SSL
-----------------------------------------------------
Файл настройки должен иметь следующий вид:

``` apache
    #$ sudo cat /etc/nginx/sites-available/debianworld.ru-2
    upstream backend1 {
      # Адрес back-end'a
      server 192.168.0.1:8080;
    }

    server {
        listen   80;
        server_name debianworld-2.ru;

        access_log /home/sites/debianworld.ru-2/logs/nginx_access.log;
        error_log /home/sites/debianworld.ru-2/logs/nginx_error.log;

        # Перенаправление на back-end
        location / {
            proxy_pass  http://backend1;
            include     /etc/nginx/proxy.conf;
        }
        # ...
    }

    server {
        listen   443;
        server_name debianworld-2.ru;

        ssl    on;
        ssl_certificate         /etc/ssl/certs/debianworld.ru.crt;
        ssl_certificate_key     /etc/ssl/private/debianworld.ru.key;

        access_log /home/sites/debianworld.ru-2/logs/nginx_ssl_access.log;
        error_log /home/sites/debianworld.ru-2/logs/nginx_ssl_error.log;

        # Перенаправление на back-end
        location / {
            proxy_pass  http://backend1;
            include     /etc/nginx/proxy.conf;
        }
        # ...
    }
```

В отличие от конфигурации для debianworld-1.ru тут уже появляется описание для 443 порта.
Идея проста - ssl-соединение создает nginx, а вот данные по этому соединению передает уже apache.

Включение хостов и перезапуск Nginx
-----------------------------------
После того, как настройки сделаны, необходимо сделать виртуальные хосты достпными и перезапустить nginx:

``` bash
    $ sudo ln -s /etc/nginx/sites-available/debianworld.ru-1 /etc/nginx/sites-enabled/debianworld.ru-1
    $ sudo ln -s /etc/nginx/sites-available/debianworld.ru-2-ssl /etc/nginx/sites-enabled/debianworld.ru-2-ssl
    $ sudo /etc/init.d/nginx restart
```
Создание виртуальных хостов в Apache
====================================
Так как ssl-соединениями занимается nginx, то apache остается всего лишь работать на не стандартном порту (например, 8080) и обрабатывает входящие содинения.
Подробнее о настройке Apache как бэкенда можно узнать в статье [Установка nginx как front-end к apache в Debian / Ubuntu - 2](http://debianworld.ru/articles/ustanovka-nginx-kak-front-end-k-apache-v-debian-ubuntu-2/ "Настройка Apache как бэкенда ##index##").

Создаем файлы виртуальных хостов Apache:

``` apache
    #$ sudo cat /etc/apache2/sites-available/debianworld-1.ru
    <VirtualHost *:8080>
      # Осн. настройки домена
      ServerAdmin admin@debianworld-1.ru
      ServerName debianworld-1.ru

      DocumentRoot /home/sites/debianworld.ru-1/apache/
      <Directory /home/sites/debianworld.ru-1/apache/>
          Order deny,allow
          Allow from all
      </Directory>

      ErrorLog  /home/sites/debianworld.ru-1/logs/apache_error.log
      CustomLog /home/sites/debianworld.ru-1/logs/apache_access.log combined

      # Остальные настройки
      # ...
    </VirtualHost>
```

Второй хост:

``` apache
    #$ sudo cat /etc/apache2/sites-available/debianworld-2.ru
    <VirtualHost *:8080>
      # Осн. настройки домена
      ServerAdmin admin@debianworld-2.ru
      ServerName debianworld-2.ru

      DocumentRoot /home/sites/debianworld.ru-2/apache/
      <Directory /home/sites/debianworld.ru-2/apache/>
          Order deny,allow
          Allow from all
      </Directory>

      ErrorLog  /home/sites/debianworld.ru-2/logs/apache_error.log
      CustomLog /home/sites/debianworld.ru-2/logs/apache_access.log combined

      # Остальные настройки
      # ...
    </VirtualHost>
```

Далее, необходимо включить хосты и перегрузить apache:

``` bash
    $ sudo a2ensite debianworld-1.ru
    $ sudo a2ensite debianworld-2.ru
    $ sudo /etc/init.d/apache2 restart
```
Проверка SSL соединения
======================
Чтобы проверить корректность настройки SSL достаточно открыть в браузере https://debianworld-2.ru/.
Так как используется самоподписанный сертификат, то браузер, вероятнее всего, выдаст предупреждение, что подлинность сервера не может быть проверена, и предоставит возможность просмотреть сертификат. В случае, если текущий домен не совпадает с тем, что указан "Common Name", может быть выдано еще одно предупреждение.

Самоподписанных сертификтов как правило хватает для административных зон на сайтах.
При использовании коммерческих сертификатов никаких предупреждений выдаваться не будет.

Для более тонкой настройки SSL или для решения проблем в TLS/SSL-соединениях следует пользоваться набором утилит openssl. Например:

``` bash
    $ openssl s_client -connect debianworld-2.ru:443
```
