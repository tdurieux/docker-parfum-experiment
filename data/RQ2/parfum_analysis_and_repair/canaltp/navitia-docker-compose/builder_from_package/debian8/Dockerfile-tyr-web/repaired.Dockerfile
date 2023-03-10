FROM navitia/master

COPY navitia-common_*.deb ./
COPY navitia-tyr_*.deb ./

# install navitia-common package
RUN dpkg -i ./navitia-common_*.deb || exit 0
RUN apt-get install -f -y

# install navitia-tyr package
RUN dpkg -i ./navitia-tyr_*.deb || exit 0
RUN apt-get install -f -y

# install tyr requirements
RUN pip install --no-cache-dir -r /usr/share/tyr/requirements.txt

# install uwsgi
RUN pip install --no-cache-dir uwsgi

COPY tyr_settings.py /srv/navitia/settings.py
ENV TYR_CONFIG_FILE=/srv/navitia/settings.py

WORKDIR /usr/src/app/
RUN cp /usr/bin/manage_tyr.py /usr/src/app/manage_tyr.py



CMD ["uwsgi",  "--mount", "/=tyr:app",  "--http", "0.0.0.0:80"]
