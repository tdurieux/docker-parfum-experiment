FROM alpine:latest

COPY command-executer .

CMD ./command-executer listen --port 5005