FROM gcr.io/cloud-builders/docker
COPY ./bin/rocker /usr/bin/rocker
ENTRYPOINT ["/usr/bin/rocker"]
