# Ansible Script to Install Nginx + RTMP Streaming server

- Compilation script 
	- [https://obsproject.com/forum/resources/how-to-set-up-your-own-private-rtmp-server-using-nginx.50/](https://obsproject.com/forum/resources/how-to-set-up-your-own-private-rtmp-server-using-nginx.50/)
	- [https://www.vultr.com/docs/setup-nginx-rtmp-on-ubuntu-14-04](https://www.vultr.com/docs/setup-nginx-rtmp-on-ubuntu-14-04)
- [Script for Systemd startup](https://www.linode.com/docs/websites/nginx/install-nginx-web-server-on-debian-8)

## Additional Scripts

### Create DB User

```
sudo -u postgres createuser -d -P videouploader
cd /srv/apps/video_uploader
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
```

### Run Sidekiq

```
bundle exec sidekiq -e production -d -L ./log/sidekiq.log
```

### Run Event Scrapers

```
RAILS_ENV=production rake scraper:webuildsg
RAILS_ENV=production rake scraper:fossasia
```

Or you may create a default scraper by setting `ENV['DEFAULT_SCRAPER']` to the specific scraper and set this up as a cronjob.

```
RAILS_ENV=production rake scraper:run
```

### Create Admin Users

```
RAILS_ENV=production rake db:seed
```