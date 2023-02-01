FROM node:11-slim

RUN apt-get update -qq && apt-get install --no-install-recommends -y -qq build-essential rsync nginx && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY front-end/package.json /usr/src/app
COPY front-end/ /usr/src/app/
COPY api/resources/schema.graphql /usr/src/app/packages/graphql/schema.graphql

COPY front-end/nginx.conf /etc/nginx/nginx.conf

RUN make setup

CMD ["make", "run-w-proxy"]
