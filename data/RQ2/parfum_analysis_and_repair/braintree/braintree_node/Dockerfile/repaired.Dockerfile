FROM debian:stretch

RUN apt-get update
RUN apt-get -y --no-install-recommends install curl gpg rake && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /braintree-node
