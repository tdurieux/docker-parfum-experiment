FROM node:8-jessie as build

ENV DEST=/opt/wikipedia-monitor

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libicu-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir $DEST
WORKDIR $DEST
ADD package.json *.js $DEST/
RUN npm install && npm cache clean --force;

FROM node:8-jessie

ENV DEST=/opt/wikipedia-monitor

RUN apt-get update && apt-get install --no-install-recommends -y libicu52 && rm -rf /var/lib/apt/lists/*;
COPY --from=build $DEST/ $DEST/
WORKDIR $DEST

CMD ["node", "monitor.js"]
