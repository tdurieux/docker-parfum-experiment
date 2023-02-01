# docker build -t nightscout-ps1-build:debian -f Dockerfile.debian .
# docker run -it --rm -v $PWD:/nightscout-ps1 nightscout-ps1-build:debian
FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  python && rm -rf /var/lib/apt/lists/*;

WORKDIR /nightscout-ps1

CMD make build && cp -v ./out/Default/nightscout-ps1 ./packed/ && make clean
