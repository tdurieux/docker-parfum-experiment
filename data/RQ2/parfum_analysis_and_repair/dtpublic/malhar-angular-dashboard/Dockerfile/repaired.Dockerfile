FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends git wget -y && wget -qO- https://deb.nodesource.com/setup_4.x | sudo bash - && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends nodejs -y && npm install -g bower gulp && npm install gulp && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
EXPOSE 3000
WORKDIR /usr/src/app
ADD . /usr/src/app
RUN bower install --allow-root && npm install && npm cache clean --force;
RUN gulp
