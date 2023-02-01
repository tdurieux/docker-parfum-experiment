FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -yf vim && rm -rf /var/lib/apt/lists/*;

COPY test.vimrc /root/.vimrc
