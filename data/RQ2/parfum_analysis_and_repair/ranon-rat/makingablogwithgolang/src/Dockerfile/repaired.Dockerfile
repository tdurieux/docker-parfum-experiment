FROM golang:alpine

COPY . ./blog
WORKDIR /go/blog/
RUN apk update && apk upgrade && apk add --no-cache build-base
# install the dependencies
RUN apk add --no-cache sqlite && apk add --no-cache npm && apk add --no-cache zip
RUN npm install -g typescript && npm cache clean --force;
# init the database
RUN cat database/inicialize.sql | sqlite3 database/publications.db

# compile some stuff
WORKDIR /go/blog/public/script

RUN tsc *.ts
RUN rm -rf *.ts
RUN unzip *.zip
RUN unzip *.zip ;rm -rf *.zip
WORKDIR /go/blog/public/style
# delete some things
RUN unzip *.zip ;rm -rf *.zip

WORKDIR /go/blog/
#compile
RUN go build main.go
# delete
RUN  rm -rf database/inicialize.sql
RUN  apk del npm && apk del zip

CMD ["./main"]
