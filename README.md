# Sinatra-Skeleton
Sinatraアプリケーションを最短で構築する個人用リポジトリ

## 構成要素

* Debian-jessie-amd64-netboot 3.16.0-4-amd64
* nginx 1.10.2
* ruby 2.2.2
* gem 2.4.5
* bundle 1.13.4
* unicorn-5.2.0
* sinatra-1.4.7

## 構築手順

* リポジトリをローカルに
```
git clone git@github.com:Sa2Knight/Sinatra-Skeleton.git
```

* ライブラリをダウンロード
```
sudo bundle install --path vendor/bundle
```

* unicorn.rbを編集(パスをいい感じに差し替える)
```
# coding: utf-8

@path = '/home/vagrant/appname/'
@path.chomp!
worker_processes 1
working_directory @path
timeout 300
preload_app true
listen "#{@path}/shared/tmp/unicorn.sock" , backlog: 1024
pid "#{@path}/shared/tmp/unicorn.pid"
stderr_path "#{@path}/logs/stderr.log"
stdout_path "#{@path}/logs/stdout.log"
```

* nginxを適当に導入して、設定を弄る(パスとかポートを適宜変える)
```
$ sudo vim /etc/nginx/nginx.conf

user  vagrant;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    #include /etc/nginx/conf.d/*.conf;

    proxy_buffer_size   512k;
    proxy_buffers   4 512k;
    proxy_busy_buffers_size   512k;

    upstream unicorn {
        server unix:/home/vagrant/appname/shared/tmp/unicorn.sock;
    }

    server {
        listen 8080;
	client_max_body_size 2M;
        server_name appname;
        root /home/vagrant/appname/app/public;
        access_log /home/vagrant/appname/logs/access.log;
        error_log /home/vagrant/appname/logs/error.log;
        try_files $uri/index.html $uri @unicorn;
        location @unicorn {
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_pass http://unicorn;
        }
    }
}
```

* nginxを再起動
```
$ sudo service nginx restart
```

* アプリケーションを起動
```
$ sudo bundle exec unicorn -c unicorn.rb
```

* localhsot:8080にアクセス

Herro,Sinatra
って表示されればおｋ
