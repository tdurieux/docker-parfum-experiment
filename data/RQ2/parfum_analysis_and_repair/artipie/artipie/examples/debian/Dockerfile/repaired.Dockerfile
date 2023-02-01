FROM debian:10.8-slim

WORKDIR /test
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN echo "deb [trusted=yes] http://artipie.artipie:8080/my-debian my-debian main" > \
  /etc/apt/sources.list
COPY ./run.sh aglfn_1.7-3_amd64.deb /test/
CMD "/test/run.sh"
