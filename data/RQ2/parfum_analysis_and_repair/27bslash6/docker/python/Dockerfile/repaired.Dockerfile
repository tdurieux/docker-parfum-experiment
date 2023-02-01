FROM funkygibbon/ubuntu

RUN apt-get update && apt-get -y --no-install-recommends install python && apt-get clean && rm -fr /var/lib/apt/lists/*
