FROM showwin/ishocon2_app_base:latest
ENV APP_LANG 'PHP'

# PHP のインストール
RUN sudo mkdir /run/php
RUN sudo apt install -y php php-fpm php-mysql php-cli

# アプリケーション
RUN mkdir /home/ishocon/data /home/ishocon/webapp
COPY admin/ishocon2.dump.tar.bz2 /home/ishocon/data/ishocon2.dump.tar.bz2
COPY webapp/ /home/ishocon/webapp
COPY admin/config/bashrc /home/ishocon/.bashrc

# ライブラリのインストール
RUN cd /home/ishocon/webapp/php && \
    sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    sudo php composer-setup.php && \
    sudo php -r "unlink('composer-setup.php');" && \
    sudo php ./composer.phar install

WORKDIR /home/ishocon
EXPOSE 443

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

# FIXME: ここでアプリケーションが起動するように README を参考に書き直す
CMD cd ~/webapp/php && cat README.md
