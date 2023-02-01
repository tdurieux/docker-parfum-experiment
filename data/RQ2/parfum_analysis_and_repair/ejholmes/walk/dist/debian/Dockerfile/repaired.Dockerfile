FROM debian

RUN apt-get update && apt-get install --no-install-recommends -y man && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /walk
WORKDIR /
COPY . /walk

RUN dpkg-deb --build walk && \
    dpkg -i walk.deb && \
    man -P cat walk
