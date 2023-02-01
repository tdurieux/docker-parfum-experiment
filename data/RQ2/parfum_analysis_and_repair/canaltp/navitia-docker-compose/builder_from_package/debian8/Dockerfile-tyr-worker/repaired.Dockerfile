FROM navitia/master

COPY navitia-common_*deb ./
COPY navitia-tyr_*.deb ./
COPY navitia-ed_*.deb ./
COPY navitia-cities_*.deb ./
COPY mimirsbrunn_*.deb ./
COPY cosmogony2cities_*.deb ./

# install navitia-common package
RUN dpkg -i ./navitia-common_*.deb || exit 0
RUN apt-get install -f -y

# install navitia-tyr package
RUN dpkg -i ./navitia-tyr_*.deb || exit 0
RUN apt-get install -f -y

# install navitia-ed package
RUN dpkg -i ./navitia-ed_*.deb || exit 0
RUN apt-get install -f -y

# install navitia-cities package
RUN dpkg -i ./navitia-cities_*.deb || exit 0
RUN apt-get install -f -y

# install navitia-mimirsbrunn package
RUN dpkg -i ./mimirsbrunn_jessie-*.deb || exit 0
RUN apt-get install -f -y

# install cosmogony2cities package
RUN dpkg -i ./cosmogony2cities*.deb || exit 0
RUN apt-get install -f -y

# install tyr requirements
RUN pip install --no-cache-dir -r /usr/share/tyr/requirements.txt

EXPOSE 5000

COPY tyr_settings.py /

WORKDIR /usr/src/app/
RUN cp /usr/bin/manage_tyr.py /usr/src/app/manage_tyr.py

# TODO change the user to remove this ugly C_FORCE_ROOT
ENV TYR_CONFIG_FILE=/tyr_settings.py
ENV C_FORCE_ROOT=1
CMD ["celery", "worker", "-A", "tyr.tasks", "-O", "fair"]
