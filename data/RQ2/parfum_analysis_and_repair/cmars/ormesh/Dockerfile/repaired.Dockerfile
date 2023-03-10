FROM debian:stretch-slim
RUN apt-get update
RUN apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade -y
RUN echo "deb http://deb.torproject.org/torproject.org stretch main" | tee /etc/apt/sources.list.d/tor.list
RUN echo "deb-src http://deb.torproject.org/torproject.org stretch main" | tee -a /etc/apt/sources.list.d/tor.list
RUN gpg --batch --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
RUN gpg --batch --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
RUN apt-get update
RUN apt-get install --no-install-recommends -y tor deb.torproject.org-keyring && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/lib/ormesh
ENV HOME /var/lib/ormesh
VOLUME /var/lib/ormesh
COPY ormesh /
ENTRYPOINT ["/ormesh", "agent", "run"]
