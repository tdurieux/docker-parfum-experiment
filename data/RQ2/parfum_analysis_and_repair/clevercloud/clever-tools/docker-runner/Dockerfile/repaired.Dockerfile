# Published to https://hub.docker.com/r/clevercloud/clever-tools-builder

FROM jenkins/jnlp-slave

USER root

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y rpm && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y ruby ruby-dev rubygems build-essential && rm -rf /var/lib/apt/lists/*;
RUN gem install --no-ri --no-rdoc fpm

USER jenkins
