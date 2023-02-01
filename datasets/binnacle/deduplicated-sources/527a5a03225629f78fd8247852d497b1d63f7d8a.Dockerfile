FROM ruby:2.3.1

MAINTAINER Fredrik Vihlborg <fredrik.wihlborg@gmail.com>
RUN apt-get update && \
    apt-get -y install nodejs && \
    apt-get -y clean
RUN gem install bundler dashing
RUN mkdir /dashing && \
    dashing new dashing && \
    cd /dashing && \
    bundle && \
    ln -s /dashing/dashboards /dashboards && \
    ln -s /dashing/jobs /jobs && \
    ln -s /dashing/assets /assets && \
    ln -s /dashing/lib /lib-dashing && \
    ln -s /dashing/public /public && \
    ln -s /dashing/widgets /widgets && \
    mkdir /dashing/config && \
    mv /dashing/config.ru /dashing/config/config.ru && \
    ln -s /dashing/config/config.ru /dashing/config.ru && \
    ln -s /dashing/config /config

COPY run.sh /

VOLUME ["/dashboards", "/jobs", "/lib-dashing", "/config", "/public", "/widgets", "/assets"]

ENV PORT 3030
EXPOSE $PORT
WORKDIR /dashing

CMD ["/run.sh"]

