FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install g++ \
                       gcc \
                       git \
                       make \
                       zip && rm -rf /var/lib/apt/lists/*;
COPY . /bannertool
WORKDIR /bannertool
CMD ["make"]
