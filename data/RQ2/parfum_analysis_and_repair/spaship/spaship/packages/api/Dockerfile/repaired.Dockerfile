FROM ubuntu:20.04

RUN apt-get update
RUN apt-get --force-yes upgrade  -y
RUN apt-get dist-upgrade
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;
RUN sudo apt update
RUN sudo curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN sudo apt-get --force-yes --no-install-recommends install -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends --yes build-essential && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install -y --no-install-recommends --only-upgrade bash && rm -rf /var/lib/apt/lists/*;
RUN sudo apt --force-yes --no-install-recommends install -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get --force-yes --no-install-recommends install -y libpcre3 libpcre3-dev && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install -y --no-install-recommends libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN sudo apt --force-yes --no-install-recommends install -y libgit2-dev && rm -rf /var/lib/apt/lists/*;

RUN sudo dpkg --add-architecture i386
RUN sudo apt-get update
RUN sudo apt-get --force-yes --no-install-recommends install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 && rm -rf /var/lib/apt/lists/*;
RUN node -v

RUN mkdir app && mkdir app/tmp && mkdir app/tmp/spaship_uploads && mkdir app/root
RUN sudo chown -R $USER:$(id -gn $USER) /app
USER $USER

RUN sudo mkdir ~/.config
RUN sudo chown -R $USER:$(id -gn $USER) ~/.config

ADD . /app
WORKDIR /app

RUN find . -name "node_modules" -exec rm -rf '{}' +
RUN rm -rf '/app/package-lock.json'

RUN sudo apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;
RUN sudo npm install -g npm-check-updates && npm cache clean --force;
RUN npm cache clean --force
RUN sudo chmod -R 777 /app
RUN ls && npm install && npm cache clean --force;

EXPOSE 2345

CMD [ "npm", "run", "start"]