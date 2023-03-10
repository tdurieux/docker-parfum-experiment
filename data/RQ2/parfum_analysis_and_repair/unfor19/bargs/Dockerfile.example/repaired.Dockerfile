FROM alpine:3.14
RUN apk add --no-cache util-linux bash
WORKDIR /code
COPY . .
ENV LANG "en_US.UTF-8"
ENTRYPOINT [ "bash", "example.sh" ]