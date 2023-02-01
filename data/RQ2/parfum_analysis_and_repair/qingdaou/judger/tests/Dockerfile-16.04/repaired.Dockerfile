FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y cmake python python3 libseccomp-dev gcc g++ && rm -rf /var/lib/apt/lists/*;
WORKDIR /src
