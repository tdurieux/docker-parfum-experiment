FROM snapcore/snapcraft:stable

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential git-core unzip curl pkg-config rpm && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm i -g grunt-cli && npm cache clean --force;

ENTRYPOINT ["/entrypoint.sh"]
