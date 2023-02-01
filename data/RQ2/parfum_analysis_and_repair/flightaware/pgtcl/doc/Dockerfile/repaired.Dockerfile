FROM debian:stable-slim

RUN apt-get update -qq && \
    apt install --no-install-recommends -y docbook-utils ghostscript make patch ed docbook-xsl tidy docbook5-xml && rm -rf /var/lib/apt/lists/*;

RUN mkdir /root/doc
WORKDIR /root/doc
