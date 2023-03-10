FROM registry.opensource.zalan.do/stups/node:8.4.0-28
MAINTAINER maximilian.fellner@zalando.de

RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/tessellate

COPY package.json package.json

RUN npm install --production && npm cache clean --force;

COPY bin/ bin/
COPY dist/ dist/

ENV NODE_ENV production
ENV MORGAN_FORMAT common
ENV APP_PORT 3002
ENV DEBUG tessellate-editor:*

# HEALTHCHECK CMD ["curl",  "localhost:3002/health"]

EXPOSE 3001

CMD ["bin/tessellate-editor"]
