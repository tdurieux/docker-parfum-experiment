FROM alpine
RUN apk add --no-cache bash curl
COPY client.sh .
RUN chmod +x client.sh
ENTRYPOINT ./client.sh