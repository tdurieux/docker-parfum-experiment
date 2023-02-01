FROM alpine

RUN apk -U upgrade
RUN apk add --no-cache nmap
RUN apk add --no-cache nmap-scripts

ENTRYPOINT ["nmap"]