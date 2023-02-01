FROM       ubuntu:19.04
MAINTAINER howdays

RUN apt-get update && apt-get install --no-install-recommends -y xinetd netcat && rm -rf /var/lib/apt/lists/*;
ENV TERM=linux

RUN useradd Angel
RUN mkdir /home/Angel
WORKDIR /home/Angel

ADD problem /home/Angel
ADD flag /home/Angel
ADD xinetd /etc/xinetd.d/

RUN chmod 460 /home/Angel/*
RUN chown Angel:root /home/Angel/*
RUN chmod +x /home/Angel/problem


RUN echo "Angel 3000/tcp" >> /etc/services
EXPOSE 3000

RUN service xinetd restart
CMD ["/usr/sbin/xinetd","-dontfork"]