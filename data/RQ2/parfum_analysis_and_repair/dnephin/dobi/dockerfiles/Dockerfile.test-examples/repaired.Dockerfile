FROM    docker/compose:1.8.0

RUN apk add --no-cache -U bash git curl expect

RUN export VERSION=1.13.1; \
        curl -f -Ls https://get.docker.com/builds/Linux/x86_64/docker-$VERSION.tgz | \
        tar -xz docker/docker && \
        mv docker/docker /usr/local/bin/ && \
        rmdir docker
