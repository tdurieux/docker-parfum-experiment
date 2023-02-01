FROM debian:bullseye

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
    && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list
#COPY start.sh /start.sh
CMD ["/bin/bash"]


RUN apt-get update
RUN apt -y --no-install-recommends install wget gnupg && rm -rf /var/lib/apt/lists/*;
#RUN gpg --keyserver "hkp://keyserver.ubuntu.com:80" --recv-keys "467B942D3A79BD29" 2>&1 && break
RUN wget -q https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 -O- | apt-key add -
RUN echo "deb http://repo.mysql.com/apt/debian buster mysql-5.7" >> /etc/apt/sources.list.d/mysql.list
RUN apt-get update
RUN apt -y --no-install-recommends install libmysqlclient-dev \
               cdbs \
               devscripts \
               equivs \
               fakeroot \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;
