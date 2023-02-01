FROM node:7.2

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;