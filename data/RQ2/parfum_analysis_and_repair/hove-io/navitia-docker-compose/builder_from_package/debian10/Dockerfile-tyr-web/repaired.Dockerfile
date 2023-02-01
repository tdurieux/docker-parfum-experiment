FROM navitia/master

COPY navitia-common_*.deb navitia-tyr_*.deb ./
COPY tyr_settings.py /srv/navitia/settings.py

RUN apt-get update \
    && apt install --no-install-recommends -y python python-pip git libgeos-c1v5 ./navitia-common_*.deb ./navitia-tyr_*.deb \
    && apt-get clean \
    && rm -rf navitia-common_*.deb navitia-tyr_*.deb && rm -rf /var/lib/apt/lists/*;

# install tyr requirements
RUN pip install --no-cache-dir -r /usr/share/tyr/requirements.txt \
    && pip install --no-cache-dir uwsgi

WORKDIR /usr/src/app/

RUN cp /usr/bin/manage_tyr.py /usr/src/app/manage_tyr.py

ENV TYR_CONFIG_FILE=/srv/navitia/settings.py

CMD ["uwsgi",  "--mount", "/=tyr:app",  "--http", "0.0.0.0:80"]
