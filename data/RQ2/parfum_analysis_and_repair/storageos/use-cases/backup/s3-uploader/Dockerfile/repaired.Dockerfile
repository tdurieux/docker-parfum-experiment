FROM debian:9-slim

RUN apt-get update -qq && apt-get install --no-install-recommends -yq \
    curl \
    vim \
    less \
    python3-pip \
    rsync && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade awscli

ADD ./entrypoint.sh /entrypoint.sh
ADD ./uploader.sh /opt/uploader.sh
ADD ./syncher.sh /opt/syncher.sh
RUN chmod u+x /entrypoint.sh /opt/uploader.sh /opt/syncher.sh

CMD ["/entrypoint.sh"]
