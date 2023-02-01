FROM keymetrics/pm2:8-stretch

RUN apt-get -yqq update && \
    apt-get -yqq upgrade && \
    apt-get -yqq --no-install-recommends install libboost-all-dev libsodium-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -yqq --no-install-recommends install vim git zsh tmux silversearcher-ag && \
    curl -f -Lo- https://bit.ly/2pztvLf | bash && rm -rf /var/lib/apt/lists/*;

ENV SHELL /bin/zsh
ENV NPM_CONFIG_LOGLEVEL warn

CMD ["pm2-runtime", "start", "ecosystem.config.js", "--only", "site"]
