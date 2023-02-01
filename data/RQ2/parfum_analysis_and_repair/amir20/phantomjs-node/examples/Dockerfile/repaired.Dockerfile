FROM debian:jessie
MAINTAINER Amir Raminfar <findamir@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install --no-install-recommends -y nodejs build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev python libx11-dev libxext-dev && rm -rf /var/lib/apt/lists/*;

RUN npm install phantom && npm cache clean --force;

ADD async.js /async.js

ENTRYPOINT ["node", "/async.js"]
CMD ["http://stackoverflow.com"]
