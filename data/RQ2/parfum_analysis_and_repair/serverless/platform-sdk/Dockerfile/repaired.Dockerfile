FROM ubuntu:latest

RUN apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y screen rsync curl git && rm -rf /var/lib/apt/lists/*;

# install Node.js and update npm
RUN curl -f -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y nodejs build-essential \
  && npm install npm@latest -g && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
