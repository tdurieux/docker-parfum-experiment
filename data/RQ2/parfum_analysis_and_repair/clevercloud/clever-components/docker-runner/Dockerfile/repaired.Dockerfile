# Published to https://hub.docker.com/r/clevercloud/clever-components-builder

FROM jenkins/jnlp-slave

USER root

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

USER jenkins
