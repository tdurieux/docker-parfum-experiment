FROM alpine
RUN apk add --no-cache busybox-extras curl
WORKDIR /app
ADD . .
RUN ./compile.sh
ENTRYPOINT ./start.sh ./main.sh
