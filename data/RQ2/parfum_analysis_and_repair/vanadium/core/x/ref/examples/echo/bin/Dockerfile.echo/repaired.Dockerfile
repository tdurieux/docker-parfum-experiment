FROM alpine
COPY echo /bin/echo
COPY creds/ /bin/creds/
ENTRYPOINT ["/bin/echo"]