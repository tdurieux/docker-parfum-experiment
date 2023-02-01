FROM  alpine:latest
RUN apk update && apk add --no-cache figlet
ADD   ./message /message
CMD   cat /message | figlet

