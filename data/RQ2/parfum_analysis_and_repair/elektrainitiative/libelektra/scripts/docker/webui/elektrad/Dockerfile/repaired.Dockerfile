# image that only starts elektrad

FROM elektra/web-base:latest

WORKDIR /home/elektra
USER elektra

# run elektrad