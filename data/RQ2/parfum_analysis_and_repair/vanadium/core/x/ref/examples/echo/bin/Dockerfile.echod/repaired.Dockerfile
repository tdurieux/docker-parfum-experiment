FROM alpine
COPY echod /bin/echod
COPY creds/ /bin/creds/
ENTRYPOINT ["/bin/echod"]