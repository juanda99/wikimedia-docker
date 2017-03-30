# wikimedia
WIP!

# How to install
- Clone the repo
```
git clone git@github.com:juanda99/wikimedia-docker.git  # with ssh keys
git clone https://github.com/juanda99/wikimedia-docker.git # without ssh keyes
```
- Start the containers
```
cd wikimedia-docker
docker-compose up -d
```

# Configuration
- Database users and instance: file db-users.yml
- Mediawiki:
  - First time you should configure env parameters in file docker-compose.yml for the standalone installation (it configures your own LocalSettings.php)
  ```
      MEDIAWIKI_SITE_NAME: MediaWiki
      MEDIAWIKI_SITE_SERVER: //localhost:8088
      MEDIAWIKI_SITE_LANG: es
      MEDIAWIKI_ENABLE_SSL: "false"
      MEDIAWIKI_UPDATE: "false"
  ```
  - MEDIA_SITE_SERVER should resolve to localhost and the port should be previously defined in your docker-compose.file (see ports entry).
  - Set mediawiki version
    - You need to [modify dockerfile](https://github.com/juanda99/wikimedia-docker/blob/master/wiki/Dockerfile#L41)
    - By default it installs latest version (```/tmp/get-mediawiki.sh latest```), if we want an specific version we need to rewrite it: ```/tmp/get-mediawiki.sh 1.28 ```

- Apache:
  Changing apache specific file: wiki/mediawiki-apache.conf

- PHP:
  - [Change version:](https://github.com/juanda99/wikimedia-docker/blob/master/wiki/Dockerfile:L1)
  - [Add php extensions:](https://github.com/juanda99/wikimedia-docker/blob/master/wiki/Dockerfile:L18-21) [read the docs](https://hub.docker.com/_/php/)
- Mysql
  - All configuration related to mysql through docker-compose file.  [Read the docs](https://hub.docker.com/_/mysql/)
  
  
