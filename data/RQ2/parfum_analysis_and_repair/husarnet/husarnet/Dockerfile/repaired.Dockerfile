# This a development dockerfile and compose setup
# For a user specific one have a look at unix/docker-misc
FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y apt-utils && apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

WORKDIR /husarnet
COPY . .
RUN ./util/prepare-all.sh

CMD ["sleep", "6000"]
