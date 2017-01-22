#!/bin/bash

sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev unzip ffmpeg

mkdir ~/working && cd ~/working

wget https://nginx.org/download/nginx-1.11.8.tar.gz
wget -O nginx-rtmp-module.zip https://github.com/arut/nginx-rtmp-module/archive/master.zip

tar -zxvf nginx-1.11.8.tar.gz
unzip nginx-rtmp-module.zip

cd nginx-1.11.8

./configure --prefix=/opt/nginx --with-http_ssl_module --add-module=../nginx-rtmp-module-master

make
sudo make install
