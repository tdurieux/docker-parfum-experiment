FROM alpine:latest

RUN apk --update --no-cache add vim redis postgresql-client bash
ADD . /osrc
WORKDIR /osrc

CMD ["bash"]
