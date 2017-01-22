#!/bin/bash

sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev unzip

mkdir ~/working && cd ~/working

wget https://nginx.org/download/nginx-1.11.8.tar.gz
wget -O nginx-upload-module.zip https://github.com/Austinb/nginx-upload-module/archive/2.2.zip
wget -O nginx-upload-progress-module.zip https://github.com/masterzen/nginx-upload-progress-module/archive/master.zip

tar -zxvf nginx-1.11.8.tar.gz
unzip nginx-upload-module.zip
unzip nginx-upload-progress-module.zip

cd nginx-1.11.8

sudo ./configure --prefix=/opt/nginx --with-http_ssl_module --add-module=../nginx-upload-module-2.2 --add-module=../nginx-upload-progress-module-master

sudo make
sudo make install
