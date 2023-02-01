FROM yiisoftware/yii-php:7.4-apache

RUN apt-get update && apt-get install --no-install-recommends -y sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
