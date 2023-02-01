FROM alpine

RUN apk add --no-cache --update 'py-pip' && pip install --no-cache-dir elasticsearch-curator

# COPY [...]

#WORKDIR /compose

#CMD ["docker-compose", "version"]