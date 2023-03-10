FROM node:16.15.0-slim

RUN groupadd -g 880 eventkit && useradd -u 8800 -g 880 -m eventkit && \
    mkdir -p /var/lib/eventkit/ && chown eventkit:eventkit /var/lib/eventkit

RUN apt-get update && apt-get install --no-install-recommends -y \
    ruby \
    git \
    libcairo2-dev \
    libjpeg62-turbo-dev \
    libpango1.0-dev \
    libgif-dev \
    build-essential \
    g++ \
    python && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

USER eventkit

WORKDIR /var/lib/eventkit

COPY --chown=eventkit:eventkit ./package.json ./package-lock.json /var/lib/eventkit/

RUN npm install --quiet && npm cache clean --force;

ENV PATH="/home/eventkit/.gem/ruby/2.3.0/bin:$PATH"

RUN gem install --user-install coveralls-lcov

COPY ./eventkit_cloud /var/lib/eventkit/eventkit_cloud
COPY ./config/ui/ /var/lib/eventkit/

CMD ["npm", "start"]
