FROM alpine
EXPOSE 8080

# For /etc/mime.types
RUN apk add --no-cache mailcap

WORKDIR /app
COPY dist/linux_amd64/odysee_player /app/

CMD ["./odysee_player"]
