FROM node:10-jessie
RUN apt-get -qq update && apt-get -qq --no-install-recommends install -y \
            git-core && rm -rf /var/lib/apt/lists/*;

RUN useradd --create-home --shell /bin/bash parsoid
USER parsoid
WORKDIR /home/parsoid

RUN git clone \
        --depth 1 \
        --branch v0.10.0 \
        https://gerrit.wikimedia.org/r/mediawiki/services/parsoid && \
        cd parsoid && \
        npm install && npm cache clean --force;

WORKDIR /home/parsoid/parsoid
COPY config.yaml ./
CMD ["npm", "start"]
