FROM node:lts-buster

RUN mkdir $HOME/gopath
ENV GOPATH=$HOME/gopath

RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y fakeroot && rm -rf /var/lib/apt/lists/*;

RUN npm install -g --silent @angular/cli && npm cache clean --force;

RUN go get github.com/basgys/goxml2json
RUN go get github.com/gorilla/websocket

COPY build-all.sh .

CMD sh ./build-all.sh