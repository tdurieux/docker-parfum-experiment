FROM debian:stretch
RUN apt-get update && apt-get install --no-install-recommends -y graphite-carbon graphite-api gunicorn3 && rm -rf /var/lib/apt/lists/*;
RUN sed -i s/127.0.0.1:8542/0.0.0.0:80/g /etc/default/graphite-api
RUN sed -i 's/false/true/g' /etc/default/graphite-carbon
ADD build/test/dummy-graphite.start /dummy-graphite.start
ADD build/storage-schemas.conf /etc/carbon/
ADD build/carbon.conf /etc/carbon/
EXPOSE 80
EXPOSE 2003
CMD /dummy-graphite.start
VOLUME /var/lib/graphite
