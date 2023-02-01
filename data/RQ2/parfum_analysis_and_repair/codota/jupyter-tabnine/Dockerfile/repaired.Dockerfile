FROM python:3.7-alpine3.11
COPY go/cmd/server /usr/local/bin/tabnine-server
RUN apk add --no-cache build-base && pip install --no-cache-dir python-language-server
RUN chmod 777 /usr/local/bin/tabnine-server
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/tabnine-server", "-libBaseDir=/usr/local/lib", "-port=8080"]
