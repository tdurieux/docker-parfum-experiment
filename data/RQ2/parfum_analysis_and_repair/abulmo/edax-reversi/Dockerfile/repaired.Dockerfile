# simple sample

FROM gcc:4.9

RUN apt-get update && \
    apt-get install -y --no-install-recommends make && \
    apt-get install -y --no-install-recommends p7zip-full && rm -rf /var/lib/apt/lists/*;
