FROM navitia/master

COPY navitia-common_*deb navitia-tyr_*.deb navitia-ed_*.deb navitia-cities_*.deb mimirsbrunn_buster-*.deb cosmogony2cities_*.deb tyr_settings.py ./

RUN apt-get update \
    && apt install --no-install-recommends -y python python-pip git libgeos-c1v5 libpq5 \
    ./navitia-common_*.deb ./navitia-tyr_*.deb \
    ./navitia-ed_*.deb ./navitia-cities_*.deb \
    ./mimirsbrunn_buster-*.deb ./cosmogony2cities*.deb \
    && apt-get clean \
    && rm -rf ./navitia-common_*.deb ./navitia-tyr_*.deb \
    ./navitia-ed_*.deb ./navitia-cities_*.deb \
    ./mimirsbrunn_buster-*.deb ./cosmogony2cities*.deb && rm -rf /var/lib/apt/lists/*;


# install tyr requirements
RUN pip install --no-cache-dir -r /usr/share/tyr/requirements.txt

EXPOSE 5000

WORKDIR /usr/src/app/
RUN cp /usr/bin/manage_tyr.py /usr/src/app/manage_tyr.py
ENV TYR_CONFIG_FILE=/tyr_settings.py

# TODO change the user to remove this ugly C_FORCE_ROOT
ENV C_FORCE_ROOT=1
CMD ["celery", "worker", "-A", "tyr.tasks", "-O", "fair"]
