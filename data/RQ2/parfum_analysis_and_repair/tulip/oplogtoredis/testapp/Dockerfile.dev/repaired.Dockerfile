FROM node:14.17.6-bullseye

# Install Meteor
ENV METEOR_ALLOW_SUPERUSER=true

RUN apt-get update && \
  apt-get install --no-install-recommends -y g++ build-essential curl && \
  rm -rf /var/lib/apt/lists/* && \
  curl -f https://install.meteor.com/ | sh

RUN meteor create --release 2.3.6 /throwaway && rm -rf /throwaway

# Set up app
RUN mkdir /src
WORKDIR /src

CMD meteor run --port 0.0.0.0:3000 --settings settings.json
