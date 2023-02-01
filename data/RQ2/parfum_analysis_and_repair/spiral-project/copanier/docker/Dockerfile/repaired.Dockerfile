FROM debian:buster

EXPOSE 2244
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y --no-install-recommends install git python3-dev python3-venv python3-pip libcairo-dev libpango1.0-dev locales && rm -rf /var/lib/apt/lists/*;

RUN sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr 
ENV LC_ALL fr_FR.UTF-8    

COPY ./ /srv/copanier
RUN cd /srv/copanier/ && python3 -m venv /srv/copanier-venv && . /srv/copanier-venv/bin/activate && pip install --no-cache-dir wheel gunicorn && pip install --no-cache-dir -e .

RUN dpkg-reconfigure locales