FROM ubuntu:16.04
MAINTAINER Urinx <uri.lqy@gmail.com>

RUN apt-get update && \
    apt-get install --no-install-recommends -y python \
                      python-dev \
                      python-pip && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD weixin_bot.tar.gz /
WORKDIR /weixin_bot

RUN pip install --no-cache-dir -r config/requirements.txt
EXPOSE 80
ENTRYPOINT ["./weixin_bot.py"]
CMD [""]
