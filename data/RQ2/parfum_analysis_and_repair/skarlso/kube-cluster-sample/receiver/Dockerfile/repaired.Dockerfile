FROM alpine
LABEL Author="Gergely Brautigam"
RUN apk add --no-cache -u ca-certificates
COPY ./build/linux/amd64/receiver /app/

EXPOSE 8000

WORKDIR /app/
ENTRYPOINT [ "/app/receiver" ]
