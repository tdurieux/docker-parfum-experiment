FROM iudx/rabbitmq:latest

RUN apk add --no-cache erlang-hipe

CMD rabbitmq-server

