FROM alpine:3.11

RUN apk add --no-cache beanstalkd

CMD ["beanstalkd", "-V", "-b", "/data"]