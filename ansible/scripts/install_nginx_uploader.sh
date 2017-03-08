#!/bin/bash

echo "Installing prerequisite packages..."
sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev unzip htop

echo "Prepare working folder..."
mkdir -p ~/working && cd ~/working

if [ ! -f ~/working/nginx-1.11.8.tar.gz ]; then
    echo "Downloading Nginx source..."
    wget https://nginx.org/download/nginx-1.11.8.tar.gz
fi

if [ ! -f ~/working/nginx-upload-module.zip ]; then
    echo "Downloading Upload module source..."
    wget -O nginx-upload-module.zip https://github.com/Austinb/nginx-upload-module/archive/2.2.zip
fi

tar -zxvf nginx-1.11.8.tar.gz
unzip nginx-upload-module.zip

# cd nginx-1.11.8
# sudo ./configure --prefix=/opt/nginx --with-http_ssl_module --add-module=../nginx-upload-module-2.2
# sudo ./configure --prefix=/opt/nginx --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_gzip_static_module --with-http_stub_status_module --with-http_addition_module --with-cc-opt=-Wno-error --with-ld-opt='' --add-module=/root/.rbenv/versions/2.4.0/lib/ruby/gems/2.4.0/gems/passenger-5.1.2/src/nginx_module --add-module=../nginx-upload-module-2.2
# sudo make
# sudo make install
