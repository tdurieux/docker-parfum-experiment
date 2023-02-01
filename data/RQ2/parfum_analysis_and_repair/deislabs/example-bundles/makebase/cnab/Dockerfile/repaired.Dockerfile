FROM alpine:latest

RUN apk update && apk add --no-cache make

COPY app /cnab/app
COPY Dockerfile /cnab/Dockerfile

CMD [ "/cnab/app/run" ]