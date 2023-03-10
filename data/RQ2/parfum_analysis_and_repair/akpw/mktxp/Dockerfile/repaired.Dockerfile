FROM python:3-alpine
LABEL org.opencontainers.image.source github.com/akpw/mktxp
WORKDIR /mktxp
COPY . .
RUN pip install --no-cache-dir ./ && apk add --no-cache nano
EXPOSE 49090
ENTRYPOINT ["/usr/local/bin/mktxp"]
CMD ["export"]
