FROM showwin/ishocon2_app_base:latest
ENV APP_LANG 'Ruby'

# Ruby のインストール
RUN sudo apt-get install -y ruby-dev libmysqlclient-dev && \
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN PATH="$HOME/.rbenv/bin:$PATH" && \
    eval "$(rbenv init -)" && \
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    rbenv install 2.5.1 && rbenv rehash && rbenv global 2.5.1

# アプリケーション
RUN mkdir /home/ishocon/data /home/ishocon/webapp
COPY admin/ishocon2.dump.tar.bz2 /home/ishocon/data/ishocon2.dump.tar.bz2
COPY webapp/ /home/ishocon/webapp
COPY admin/config/bashrc /home/ishocon/.bashrc

# ライブラリのインストール
RUN cd /home/ishocon/webapp/ruby && sudo gem install bundler -v "1.16.1" && bundle install

WORKDIR /home/ishocon
EXPOSE 443

COPY docker/app/entrypoint.sh /home/ishocon/docker/app/entrypoint.sh
ENTRYPOINT ["/home/ishocon/docker/app/entrypoint.sh"]

CMD cd ~/webapp/ruby && unicorn -c unicorn_config.rb
