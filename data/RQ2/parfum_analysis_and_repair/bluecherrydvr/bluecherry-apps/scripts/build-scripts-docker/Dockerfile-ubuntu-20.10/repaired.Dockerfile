FROM ubuntu:groovy

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
    && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list
#    && apt-get update \
RUN apt-get update
RUN apt -y --no-install-recommends install wget gnupg && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://repo.mysql.com/RPM-GPG-KEY-mysql -O- | apt-key add -
RUN echo "deb http://repo.mysql.com/apt/ubuntu groovy mysql-5.7" >> /etc/apt/sources.list.d/mysql.list

RUN apt-get update
RUN apt install -y --no-install-recommends libmysqlclient-dev \
               build-essential \
               cdbs \
               devscripts \
               equivs \
               fakeroot \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;
