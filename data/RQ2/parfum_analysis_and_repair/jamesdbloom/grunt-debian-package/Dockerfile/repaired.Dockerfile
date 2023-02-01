FROM ubuntu:16.04
RUN apt-get autoclean -y
RUN apt-get update -y && apt-get install --no-install-recommends --fix-missing -y curl nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN npm i -g n && npm cache clean --force;
RUN n 8.10.0
RUN npm i -g npm && npm cache clean --force;
RUN npm i -g grunt-cli && npm cache clean --force;
COPY . /gdp
WORKDIR /gdp
RUN npm i && npm cache clean --force;
RUN grunt
