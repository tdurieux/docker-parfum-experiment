FROM node:14.17-slim

RUN apt update && apt install --no-install-recommends --yes \
  python \
  libicu-dev \
  libxml2-dev \
  libexpat1-dev \
  build-essential \
  git \
  make && rm -rf /var/lib/apt/lists/*;

COPY . /app
WORKDIR /app
RUN npm install --production && npm cache verify && npm cache clean --force;

RUN apt remove --yes \
  libicu-dev \
  libxml2-dev \
  libexpat1-dev \
  build-essential \
  git \
  make

RUN apt autoremove --yes

EXPOSE 8081
CMD ["source /app/st2chatops.env && /app/bin/hubot"]
