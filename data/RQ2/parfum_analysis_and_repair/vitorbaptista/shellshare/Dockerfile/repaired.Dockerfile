FROM nodesource/node:4.2.5

RUN apt-get update && apt-get install --no-install-recommends -y gnupg libkrb5-dev && rm -rf /var/lib/apt/lists/*;
RUN npm install -g gulp-cli && npm cache clean --force;


COPY . /shellshare/

WORKDIR /shellshare
RUN npm set unsafe-perm true
RUN npm install && npm cache clean --force;
# HEALTHCHECK --interval=5m30s --timeout=3s CMD curl -f http://localhost:3000/ || exit 1
