FROM golang:alpine
WORKDIR /src
RUN apk add --no-cache --update npm git
RUN go get -u github.com/jteeuwen/go-bindata/...
COPY ./webapp/package.json webapp/package.json
RUN cd ./webapp && \
    npm install && npm cache clean --force;
COPY . .
RUN cd ./webapp && \
    npm run build
RUN cd ./migrations && \
    go-bindata  -pkg migrations .
RUN go-bindata  -pkg tmpl -o ./tmpl/bindata.go  ./tmpl/ && \
    go-bindata  -pkg webapp -o ./webapp/bindata.go  ./webapp/build/...   

RUN go build -o /opt/featmap/featmap && \
    chmod 775 /opt/featmap/featmap

ENTRYPOINT cd /opt/featmap && ./featmap
