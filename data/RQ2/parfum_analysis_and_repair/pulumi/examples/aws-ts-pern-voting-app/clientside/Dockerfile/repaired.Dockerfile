FROM ubuntu:18.04

WORKDIR /

EXPOSE 3000

RUN apt update && \
    apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ADD client/package.json /client/package.json

RUN cd client && npm install && npm cache clean --force;

ADD client /client

RUN cd client && npm run build

CMD [ "/client/startClient.sh" ]
