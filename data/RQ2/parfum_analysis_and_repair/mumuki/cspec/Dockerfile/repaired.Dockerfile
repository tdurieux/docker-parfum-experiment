FROM alpine:3.15.2

RUN apk add --no-cache build-base libc6-compat

WORKDIR /cspec/

COPY . .

RUN make && make install

CMD [ "/bin/sh" ]