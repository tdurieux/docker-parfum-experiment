FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y -qq graphite-web && rm -rf /var/lib/apt/lists/*;
COPY local_settings.py /etc/graphite
RUN graphite-manage syncdb --noinput
CMD graphite-manage runserver 0.0.0.0:80
EXPOSE 80
