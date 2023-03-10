FROM navitia/python

WORKDIR /usr/src/app
COPY navitia/source/tyr/requirements.txt /usr/src/app
COPY navitia/source/tyr/tyr /usr/src/app/tyr
COPY navitia/source/tyr/manage_tyr.py /usr/src/app/
COPY navitia/source/tyr/migrations /usr/src/app/migrations
COPY navitia/source/navitiacommon/navitiacommon /usr/src/app/navitiacommon


RUN apt-get update --fix-missing \
    &&  apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
        python-dev \
        build-essential \
        libgeos-c1 \
        python-dev \
        libpq-dev \
        postgresql-client \
        python-setuptools \
        git \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get autoremove -y \
        python-dev \
        build-essential \ 
        libpq-dev \
        python-setuptools \
        git && rm -rf /var/lib/apt/lists/*;

COPY tyr_settings.py /srv/navitia/settings.py

COPY run_tyr_beat.sh /
RUN chmod +x /run_tyr_beat.sh

CMD ["sh", "/run_tyr_beat.sh"]
