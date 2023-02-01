# See: https://github.com/phusion/passenger-docker
# Latest image versions: https://github.com/phusion/passenger-docker/blob/master/CHANGELOG.md
FROM phusion/passenger-ruby26:1.0.10

ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# prevent gpg from using IPv6 to connect to keyservers
RUN mkdir -p ~/.gnupg
RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

# Yarn package
RUN curl -f -sS https://raw.githubusercontent.com/yarnpkg/releases/gh-pages/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Postgres
RUN curl -f -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update -qq && apt-get dist-upgrade --yes && \
  apt-get install --no-install-recommends --yes pkg-config apt-utils build-essential cmake automake \
  && apt-get upgrade --fix-missing --yes --allow-remove-essential \
  -o Dpkg::Options::="--force-confold" && rm -rf /var/lib/apt/lists/*;

  RUN apt-get install --no-install-recommends --yes tzdata udev locales curl git gnupg ca-certificates \
      libpq-dev nodejs wget libxrender1 libxext6 libsodium23 libsodium-dev yarn \
      gcc make zlib1g-dev sqlite3 libgmp-dev libc6-dev gcc-multilib g++-multilib \
      && apt-get clean && apt-get autoremove --yes \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use en_CA.utf8 as our locale
RUN locale-gen en_CA.utf8
ENV LANG en_CA.utf8
ENV LANGUAGE en_CA:en
ENV LC_ALL en_CA.utf8

# Container uses 999 for docker user
RUN /usr/sbin/usermod -u 999 app

#ADD rails-env.conf /etc/nginx/main.d/rails-env.conf
#RUN chmod 644 /etc/nginx/main.d/rails-env.conf
ENV APP_HOME /home/app/workshops
ADD . $APP_HOME
WORKDIR $APP_HOME
RUN rm docker-compose.yml
RUN rm Dockerfile
RUN touch config/app.yml
RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
RUN chown app -R ./

EXPOSE 80 443
ADD entrypoint.sh /sbin/
RUN rm entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
RUN mkdir -p /etc/my_init.d
RUN ln -s /sbin/entrypoint.sh /etc/my_init.d/entrypoint.sh
RUN echo 'export PATH=$PATH:./bin:/usr/local/rvm/rubies/ruby-2.6.6/bin' >> /root/.bashrc
RUN echo 'alias rspec="bundle exec rspec"' >> /root/.bashrc
ENTRYPOINT ["/sbin/entrypoint.sh"]
