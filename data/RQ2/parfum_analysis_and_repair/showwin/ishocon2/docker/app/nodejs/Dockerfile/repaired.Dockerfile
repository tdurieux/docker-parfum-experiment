FROM showwin/ishocon2_app_base:latest
ENV APP_LANG 'Node.js'

# NodeJS のインストール
RUN sudo apt install --no-install-recommends -y nodejs-dev node-gyp libssl1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN sudo apt install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;

# アプリケーション
RUN mkdir /home/ishocon/data /home/ishocon/webapp
COPY admin/ishocon2.dump.tar.bz2 /home/ishocon/data/ishocon2.dump.tar.bz2
COPY webapp/ /home/ishocon/webapp
COPY admin/config/bashrc /home/ishocon/.bashrc

# ライブラリのインストール
RUN cd /home/ishocon/webapp/nodejs && \
    sudo npm install && npm cache clean --force;

WORKDIR /home/ishocon
EXPOSE 443

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

CMD cd ~/webapp/nodejs && npm install && node index.js
