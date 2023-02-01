FROM php:7.4-fpm

# composerのインストール (マルチステージビルド)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# npmのインストール (マルチステージビルド)
COPY --from=node:10.22 /usr/local/bin /usr/local/bin
COPY --from=node:10.22 /usr/local/lib /usr/local/lib

#パッケージ管理ツールapt-getの更新と必要パッケージのインストール
RUN apt-get update --allow-releaseinfo-change \
&& apt-get install --no-install-recommends -y \
git \
zip \
unzip \
&& docker-php-ext-install pdo_mysql bcmath && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www/html/laravel
