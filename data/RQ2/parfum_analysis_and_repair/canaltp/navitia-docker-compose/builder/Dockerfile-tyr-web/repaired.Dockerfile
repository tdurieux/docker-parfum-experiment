FROM navitia/python

WORKDIR /usr/src/app
COPY navitia/source/tyr/requirements.txt /usr/src/app
COPY navitia/source/tyr/tyr /usr/src/app/tyr
COPY navitia/source/tyr/manage_tyr.py /usr/src/app/
COPY navitia/source/navitiacommon/navitiacommon /usr/src/app/navitiacommon

RUN apt-get update --fix-missing \
    &&  apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
        python-dev \
        build-essential \
        libgeos-c1 \
        libpq5 \
        libpq-dev \
        python-setuptools \
        git \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get autoremove -y \
        python-dev \
        build-essential \
        python-setuptools \
        git && rm -rf /var/lib/apt/lists/*;

COPY tyr_settings.py /srv/navitia/settings.py

ENV TYR_CONFIG_FILE=/srv/navitia/settings.py
ENV PYTHONPATH=.:../navitiacommon
CMD ["uwsgi",  "--mount", "/=tyr:app",  "--http", "0.0.0.0:80"]
