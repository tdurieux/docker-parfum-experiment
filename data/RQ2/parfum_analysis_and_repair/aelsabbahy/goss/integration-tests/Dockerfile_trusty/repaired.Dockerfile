FROM ubuntu-upstart:trusty
MAINTAINER Ahmed

RUN apt-get update && \
    apt-get install --no-install-recommends -y apache2=2.4.7-1ubuntu4.22 tinyproxy && \
    apt-get remove -y vim-tiny && \
    apt-get clean && \
    echo manual > /etc/init/apache2.override && rm -rf /var/lib/apt/lists/*;

RUN sed -i '/reload|force-reload)/i  status) pidof tinyproxy > /dev/null && echo "tinyproxy is running";;' /etc/init.d/tinyproxy
RUN sed -i '/start)/a\        touch /var/log/tinyproxy/tinyproxy.log /var/run/tinyproxy/tinyproxy.pid' /etc/init.d/tinyproxy

RUN update-rc.d apache2 defaults
RUN update-rc.d tinyproxy defaults
RUN mkfifo /pipe
