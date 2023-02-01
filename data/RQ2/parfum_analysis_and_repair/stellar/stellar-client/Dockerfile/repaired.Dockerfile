FROM ubuntu:16.04 as build

MAINTAINER SDF Ops Team <ops@stellar.org>


RUN apt-get update && apt-get install --no-install-recommends -y curl git make g++ bzip2 apt-transport-https && \
    curl -f -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/node_6.x xenial main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ENV NODE_ENV=prd CI=true

WORKDIR /app/src

# RUN rm -rf app/bower_components && mkdir -p .npm && npm install && \
#     ./node_modules/.bin/bower --allow-root install && ./node_modules/.bin/gulp dist
ADD package.json .
ADD bower.json .
ADD .bowerrc .
RUN npm install && npm cache clean --force;
RUN ./node_modules/.bin/bower --allow-root install


ADD . /app/src
RUN npm run build

FROM nginx:1.17

COPY --from=build /app/src/dist/ /usr/share/nginx/html/
