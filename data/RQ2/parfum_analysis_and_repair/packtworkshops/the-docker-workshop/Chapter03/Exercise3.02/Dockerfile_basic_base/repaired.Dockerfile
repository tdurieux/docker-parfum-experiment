FROM alpine

RUN apk update && apk add --no-cache wget curl

RUN wget -O test.txt https://github.com/PacktWorkshops/The-Docker-Workshop/raw/master/Chapter3/Exercise3.02/100MB.bin
