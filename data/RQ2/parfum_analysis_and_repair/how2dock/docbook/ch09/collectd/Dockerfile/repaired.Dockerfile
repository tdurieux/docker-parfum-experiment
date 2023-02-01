FROM debian:jessie

RUN apt-get update && apt-get -y --no-install-recommends install \
    collectd \
    python \
    python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN pip install --no-cache-dir docker-py

RUN groupadd -r docker && useradd -r -g docker docker

ADD docker-stats.py /opt/collectd/bin/docker-stats.py
ADD docker-report.py /opt/collectd/bin/docker-report.py
ADD collectd.conf /etc/collectd/collectd.conf

RUN chown -R docker /opt/collectd/bin

CMD ["/usr/sbin/collectd","-f"]
