FROM debian:latest

RUN apt-get update --quiet > /dev/null && \
  apt-get install -y --no-install-recommends --assume-yes --force-yes -qq \
  python-setuptools python-dev build-essential \
  python-pip libffi-dev libssl-dev ssh-client && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir butterfly && \
    pip install --no-cache-dir libsass

ENV PASSWORD=root

EXPOSE 2233

ADD bin/init.sh /init.sh
RUN chmod +x /init.sh

CMD ["/init.sh"]
