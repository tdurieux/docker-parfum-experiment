FROM golang:1.6
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs-legacy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN go get github.com/astaxie/beego && go get github.com/beego/bee
RUN go get github.com/mattn/go-sqlite3
COPY . /go/src/github.com/tfolkman/budget
WORKDIR /go/src/github.com/tfolkman/budget
RUN npm install && npm cache clean --force;
RUN ./bootstrap.sh
EXPOSE 8080
CMD ["bee", "run"]
