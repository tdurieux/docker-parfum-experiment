# -- trivial container for BGPalerter
FROM node:14-alpine as build

WORKDIR /opt/bgpalerter
COPY . .

# Makes the final image respect /etc/timezone configuration