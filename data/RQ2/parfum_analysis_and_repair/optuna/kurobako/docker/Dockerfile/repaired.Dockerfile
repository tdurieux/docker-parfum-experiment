FROM alpine

ARG KUROBAKO_VERSION=0.1.12

RUN apk --update --no-cache add && apk add --no-cache gnuplot curl font-noto
RUN curl -f -L https://github.com/optuna/kurobako/releases/download/${KUROBAKO_VERSION}/kurobako-${KUROBAKO_VERSION}.linux-amd64 -o kurobako && chmod +x kurobako && mv kurobako /usr/local/bin/
ENTRYPOINT ["kurobako"]
