FROM ubuntu:latest

RUN apt-get update && \
    apt-get -y --no-install-recommends install curl swapspace git && rm -rf /var/lib/apt/lists/*;

COPY .meteor .
RUN curl -f https://install.meteor.com/?release=1.4.1.1 | sh
