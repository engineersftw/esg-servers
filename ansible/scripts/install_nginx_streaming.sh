#!/bin/bash

sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev unzip ffmpeg

mkdir -p ~/working && cd ~/working

if [ ! -f ~/working/nginx-1.11.8.tar.gz ]; then
    wget https://nginx.org/download/nginx-1.11.8.tar.gz
fi

if [ ! -f ~/working/nginx-rtmp-module.zip ]; then
    wget -O nginx-rtmp-module.zip https://github.com/arut/nginx-rtmp-module/archive/master.zip
fi

tar -zxvf nginx-1.11.8.tar.gz
unzip nginx-rtmp-module.zip

cd nginx-1.11.8

./configure --prefix=/opt/nginx --with-http_ssl_module --add-module=../nginx-rtmp-module-master

make
sudo make install
