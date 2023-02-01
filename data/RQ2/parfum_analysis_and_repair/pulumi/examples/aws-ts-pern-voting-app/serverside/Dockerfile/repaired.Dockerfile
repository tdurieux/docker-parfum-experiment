FROM ubuntu:18.04

WORKDIR /

EXPOSE 5000

RUN apt update && \
    apt install --no-install-recommends -y curl postgresql && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ADD server /server

RUN cd server && npm install && npm cache clean --force;

CMD [ "/server/startServer.sh" ]
