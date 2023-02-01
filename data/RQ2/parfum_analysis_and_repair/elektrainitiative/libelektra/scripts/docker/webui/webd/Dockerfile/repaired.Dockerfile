# image that only starts webd

FROM elektra/web-base:latest

WORKDIR /home/elektra
USER elektra

# run webd (serves client)