FROM node:16-bullseye as dev-frontend
ENV DEBIAN_FRONTEND noninteractive
ENV NEXT_TELEMETRY_DISABLED 1
ENV PATH = "$PATH:/usr/src/app/node_modules/.bin"

RUN apt-get update && \
    apt-get install --no-install-recommends -y git zsh jq && rm -rf /var/lib/apt/lists/*;

RUN git config --global user.email "noone@noone.local" && \
    git config --global user.name "No one"

RUN npm install npm@8 -g && npm cache clean --force;

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

WORKDIR /usr/src/app
EXPOSE 3000
