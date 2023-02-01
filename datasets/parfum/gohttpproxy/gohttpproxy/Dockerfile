FROM alpine as builder
RUN apk update ; \
        apk add git go;\
        export GOPATH=/opt/go; \
        mkdir -p /opt/gohttpproxy
COPY . /opt/gohttpproxy
RUN cd /opt/gohttpproxy &&  ls -al  && go mod download &&  go build .  && ls -al 

RUN wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 \
 && chmod +x /usr/bin/dumb-init

FROM alpine 
COPY --from=builder /opt/gohttpproxy/gohttpproxy /usr/bin/gohttpproxy
COPY --from=builder /usr/bin/dumb-init /usr/bin/dumb-init

ENTRYPOINT [ "/usr/bin/dumb-init" , "--" ]

CMD ["gohttpproxy", "--addr", ":8123"]