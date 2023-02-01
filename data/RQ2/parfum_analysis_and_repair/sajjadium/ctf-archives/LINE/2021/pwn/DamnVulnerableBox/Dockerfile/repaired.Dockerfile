FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get -y --no-install-recommends install software-properties-common locales poppler-utils --fix-missing && rm -rf /var/lib/apt/lists/*;

RUN apt-get update --fix-missing -y && apt-get -y --fix-missing dist-upgrade && apt-get -y upgrade --fix-missing && apt-get -q --no-install-recommends -y install xinetd lib32z1 libextractor3 net-tools netcat sudo curl wget python3 python3-pip clang && rm -rf /var/lib/apt/lists/*;
RUN useradd ctf -s /usr/sbin/nologin

ADD start.sh /
ADD ctf /etc/xinetd.d/

ADD box /

RUN chmod a+x /box
RUN chmod a+x /start.sh

ADD flag /flag

CMD ["/bin/dash", "-c", "/start.sh"]

EXPOSE 9999

