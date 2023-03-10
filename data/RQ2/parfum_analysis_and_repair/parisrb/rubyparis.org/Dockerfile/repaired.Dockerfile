FROM ruby:2.6.4

RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install -y --no-install-recommends sudo && apt-get clean && \
    sed -i s+secure_path=.*+secure_path="$PATH"+ /etc/sudoers && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://deb.nodesource.com/setup_8.x | sudo -E bash - &&\
    apt-cache policy nodejs && \
    apt-get install --no-install-recommends -y nodejs=8.17.0-1nodesource1 && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update
RUN apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

RUN node --version

ENV GEM_HOME="/usr/src/app/vendor/.bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

ENV PATH $PATH:/node_modules/.bin:/opt/node/bin

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

WORKDIR /usr/src/app

ENTRYPOINT ["/usr/src/app/bin/docker-entrypoint.sh"]
