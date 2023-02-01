FROM node:10.4.0

RUN apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;
