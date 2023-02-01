FROM elixir:1.7.3

ENV REFRESHED_AT=2018-09-17 \
    HOME=/opt/build \
    TERM=xterm

WORKDIR /opt/build

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -y && apt-get install --no-install-recommends -y git locales nodejs yarn && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN elixir --version
RUN node -v
RUN yarn --version && yarn cache clean;

CMD ["/bin/bash"]
