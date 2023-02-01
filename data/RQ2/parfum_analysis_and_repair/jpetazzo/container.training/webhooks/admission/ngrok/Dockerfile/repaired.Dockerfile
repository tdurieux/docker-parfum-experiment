FROM alpine
RUN apk add --no-cache curl unzip
RUN curl -f -O https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN unzip ngrok-stable-linux-amd64
FROM alpine
COPY --from=0 /ngrok /usr/local/bin/ngrok

