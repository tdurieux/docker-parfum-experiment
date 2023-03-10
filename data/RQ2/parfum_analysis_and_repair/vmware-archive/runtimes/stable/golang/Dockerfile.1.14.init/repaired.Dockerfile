FROM golang:1.14

# Prepare function environment
COPY /compile-function.sh /

# Install controller
COPY server /server
RUN  chown 1000:1000 /server -R
WORKDIR /server

USER 1000