FROM alpine
COPY mounttabled /bin/mounttabled
COPY creds/ /bin/creds/
ENTRYPOINT ["/bin/mounttabled"]