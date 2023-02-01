FROM ubuntu:20.04

RUN apt-get update
RUN apt-get --force-yes upgrade  -y
RUN apt-get dist-upgrade
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;
RUN apt update
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt-get --force-yes --no-install-recommends install -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends --only-upgrade bash && rm -rf /var/lib/apt/lists/*;
RUN node -v

RUN mkdir app
RUN sudo chown -R $USER:$(id -gn $USER) /app
USER $USER

RUN sudo mkdir ~/.config
RUN sudo chown -R $USER:$(id -gn $USER) ~/.config

ADD  . /app
WORKDIR /app

RUN find . -name "node_modules" -exec rm -rf '{}' +
RUN find . -name ".next" -exec rm -rf '{}' +
RUN sudo chmod -R 777 /app
RUN sudo ls && npm install && npm cache clean --force;
RUN sudo ls && npm run build
RUN sudo chmod -R 777 /app
EXPOSE 2468

CMD [ "npm", "run", "start"]