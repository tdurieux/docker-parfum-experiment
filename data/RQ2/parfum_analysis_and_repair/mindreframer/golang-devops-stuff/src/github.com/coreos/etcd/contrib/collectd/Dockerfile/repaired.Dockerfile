FROM stackbrew/ubuntu:raring

RUN apt-get update && apt-get install --no-install-recommends -y collectd && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --group --no-create-home collectd
ADD collectd.conf /etc/collectd/collectd.conf.tmpl
ADD collectd-wrapper /bin/collectd-wrapper
RUN chown -R collectd:collectd /etc/collectd

CMD ["collectd-wrapper"]
