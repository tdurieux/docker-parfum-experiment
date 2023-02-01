FROM ubuntu:16.04 as builder

RUN apt update && apt install curl git bzip2 g++ build-essential python -y

# meteor installer doesn't work with the default tar binary
RUN apt-get install -y bsdtar \
    && cp $(which tar) $(which tar)~ \
    && ln -sf $(which bsdtar) $(which tar) \
    && curl "https://install.meteor.com/?release=1.6.0.1" \
    | sed 's/VERBOSITY="--silent"/VERBOSITY="--progress-bar"/' \
    | sh \
    && mv $(which tar)~ $(which tar)

COPY . /app

WORKDIR /app

RUN meteor npm install \
    && cd packages/rocketchat-livechat/.app \
    && meteor npm install \
    && cd -

RUN METEOR_PROFILE=1000 meteor build --server-only --allow-superuser --debug --directory /tmp/build

FROM assistify/chat-base:stretch

MAINTAINER buildmaster@rocket.chat

COPY --from=builder /tmp/build/bundle /app/bundle

RUN set -x \
 && ls -l /app \
 && cd /app/bundle/programs/server \
 && npm install \
 && npm cache clear --force \
 && chown -R rocketchat:rocketchat /app

USER rocketchat

VOLUME /app/uploads

WORKDIR /app/bundle

# needs a mongoinstance - defaults to container linking with alias 'mongo'
ENV DEPLOY_METHOD=docker \
    NODE_ENV=production \
    MONGO_URL=mongodb://mongo:27017/rocketchat \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]
