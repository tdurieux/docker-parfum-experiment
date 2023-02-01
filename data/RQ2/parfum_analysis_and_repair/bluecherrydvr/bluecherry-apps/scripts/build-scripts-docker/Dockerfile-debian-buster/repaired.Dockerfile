FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
    && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list
#COPY start.sh /start.sh
CMD ["/bin/bash"]

RUN apt --assume-yes -y --no-install-recommends install gpgv && rm -rf /var/lib/apt/lists/*;
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
               cdbs \
               devscripts \
               equivs \
               fakeroot \ 
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;
