FROM python:3.7

LABEL version="1.3"
MAINTAINER Alexey Manikin <alexey@beget.ru>

# prepare environment
ENV DEBIAN_FRONTEND noninteractive
ENV APT_GET_INSTALL apt-get install --no-install-recommends -qq -y
ENV APT_GET_UPDATE apt-get update -qq
ENV APT_GET_UPGRADE apt-get dist-upgrade -qq -y

# dist-upgrade
RUN $APT_GET_UPDATE && $APT_GET_UPGRADE

# install base utils
RUN $APT_GET_INSTALL \
    curl \
    wget \
    gnupg2 \
    xz-utils \
    unzip \
    cron

# setup msk timezone
RUN $APT_GET_UPDATE && $APT_GET_INSTALL tzdata && \
    rm -f /etc/localtime && \
    cp -f /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    chmod 644 /etc/localtime

ADD install_code.sh /usr/local/sbin/install_code.sh
RUN /bin/bash /usr/local/sbin/install_code.sh

WORKDIR /home/domain_statistic
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

ADD init.sh /sbin/startup.sh
RUN chmod 755 /sbin/startup.sh

CMD ["/sbin/startup.sh"]
# EOF
