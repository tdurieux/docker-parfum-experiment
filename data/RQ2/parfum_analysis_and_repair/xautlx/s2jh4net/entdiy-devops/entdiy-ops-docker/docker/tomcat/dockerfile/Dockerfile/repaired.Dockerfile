FROM openweb/oracle-tomcat:8-jre8

MAINTAINER LiXia "xautlx@hotmail.com"

RUN apt-get update && apt-get install -y --no-install-recommends net-tools && rm -rf /var/lib/apt/lists/*;

ENV TZ 'Asia/Chongqing'
RUN echo $TZ > /etc/timezone && \
apt-get update && apt-get install --no-install-recommends -y tzdata && \
rm /etc/localtime && \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata && \
apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

CMD ["catalina.sh", "run"]