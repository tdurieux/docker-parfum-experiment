FROM node:18-slim

RUN apt update && \
    apt install --no-install-recommends -y git && \
    mkdir /srv/hugo && rm -rf /var/lib/apt/lists/*;


RUN npm install -g postcss-cli hugo-extended@0.87.0 && npm cache clean --force;

RUN cd /srv && npm install autoprefixer && npm cache clean --force;

WORKDIR /srv/hugo
VOLUME /srv/hugo

CMD ["/bin/sh", "-c", "hugo server --bind 0.0.0.0 --navigateToChanged --templateMetrics --buildDrafts"]