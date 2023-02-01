FROM debian:stretch
WORKDIR /code
RUN apt-get update -y && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
COPY ./devops/dockerfiles/parachain-registrator/src/index.js /code
COPY ./devops/dockerfiles/parachain-registrator/src/index_ksm.js /code
COPY ./devops/dockerfiles/parachain-registrator/src/package.json /code
RUN npm install && npm cache clean --force;
ENTRYPOINT []
