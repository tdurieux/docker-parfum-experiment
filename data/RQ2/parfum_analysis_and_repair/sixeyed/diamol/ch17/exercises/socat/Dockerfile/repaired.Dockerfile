FROM debian:stretch-slim

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl=7.52.1-5+deb9u11 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y socat=1.7.3.1-2+deb9u1 && rm -rf /var/lib/apt/lists/*;
