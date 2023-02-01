FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y -qq graphite-carbon && rm -rf /var/lib/apt/lists/*;
ADD carbon.conf /etc/carbon/carbon.conf
VOLUME /var/lib/graphite/whisper/
CMD carbon-cache start --config=/etc/carbon/carbon.conf --logdir=/var/log/carbon/ --debug
EXPOSE 2003