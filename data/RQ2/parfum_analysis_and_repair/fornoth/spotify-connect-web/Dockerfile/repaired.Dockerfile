FROM armelbuild/debian:jessie
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

RUN apt-get -y --no-install-recommends install python-pip python-dev libffi-dev libasound2-dev python-alsaaudio python-gevent libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install alsa-utils && rm -rf /var/lib/apt/lists/*;

RUN wget -q -O /usr/lib/libspotify_embedded_shared.so https://github.com/sashahilton00/spotify-connect-resources/raw/master/Rocki%20Firmware/dlna_upnp/spotify/lib/libspotify_embedded_shared.so

ADD requirements.txt /usr/src/app/requirements.txt
WORKDIR /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt

ADD . /usr/src/app

ENTRYPOINT ["python", "main.py"]
EXPOSE 4000
