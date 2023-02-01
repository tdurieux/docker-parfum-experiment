FROM node:8-buster

ENV NODE_ENV=production

RUN apt update && \
    apt install --no-install-recommends -y \
        ruby && rm -rf /var/lib/apt/lists/*;

RUN npm install --global --unsafe-perm artillery artillery-plugin-publish-metrics && npm cache clean --force;

COPY . /artillery
WORKDIR /artillery

CMD /bin/bash
