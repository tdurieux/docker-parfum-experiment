FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl vim && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;