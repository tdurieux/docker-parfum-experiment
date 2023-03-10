FROM ubuntu:16.04

RUN apt-get update -qq && \
    apt-get upgrade -qqy

RUN apt-get install --no-install-recommends -qqy \
    python-virtualenv \
    libpq-dev \
    python3=3.5.* \
    python3-dev=3.5.* && rm -rf /var/lib/apt/lists/*;

#RUN useradd app

RUN mkdir -p /srv
ADD start.sh /srv/start.sh
RUN chmod +x /srv/start.sh

ADD maintenance.sh /srv/maintenance.sh
RUN chmod +x /srv/maintenance.sh

#RUN chown -R app:app /srv
#USER app

ENTRYPOINT ["/bin/bash", "/srv/start.sh"]
