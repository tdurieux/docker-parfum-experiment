FROM node:dubnium

RUN apt-get update && apt-get install --no-install-recommends -y graphicsmagick curl wget jq daemon && rm -rf /var/lib/apt/lists/*;

ENV NPM_CONFIG_LOGLEVEL       warn
ENV SAUCE                     true
ENV XUNIT                     true
ENV PORT                      8000
ENV FIXTURE_PORT              9000
ENV KARMA_PORT                8001

RUN npm install -g npm@6 && npm cache clean --force;

WORKDIR /work

COPY cmd.sh cmd.sh

CMD '/work/cmd.sh'
