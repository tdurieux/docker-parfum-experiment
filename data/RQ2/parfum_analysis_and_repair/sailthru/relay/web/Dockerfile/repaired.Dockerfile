FROM dockerfile/nodejs
EXPOSE 8080
EXPOSE 5673
RUN apt-get update && apt-get install --no-install-recommends -y -f libzmq3 libzmq3-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /relay/web
COPY ./package.json /relay/web/
RUN npm install && npm cache clean --force;
COPY ./src /relay/web/src/
COPY ./vendor /relay/web/vendor/
CMD node src/index.js tcp://0.0.0.0:5673
