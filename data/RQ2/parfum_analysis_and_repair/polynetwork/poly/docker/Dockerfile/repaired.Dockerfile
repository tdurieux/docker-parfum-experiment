# 1. Stage one: build ontology
FROM golang:1.15 AS build
WORKDIR /app
RUN git clone https://github.com/polynetwork/poly.git  && \
    cd poly && \
    make

# 2. Stage two: copy compiled binary from prev builded container(referenced by name build)
FROM ubuntu:18.04
WORKDIR /app
COPY --from=build /app/poly/poly poly


EXPOSE 20334 20335 20336 20337 20338 20339
#NOTE! we highly recommand that you put data dir to a mounted volume, e.g. --data-dir /data/Chain
#write data to docker image is *not* a best practice