FROM google/debian:wheezy
RUN apt-get update && apt-get install --no-install-recommends -y gdebi-core && rm -rf /var/lib/apt/lists/*;
ADD *.deb /tmp/
RUN gdebi -n /tmp/*.deb
