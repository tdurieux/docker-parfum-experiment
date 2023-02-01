FROM python:3.9-buster

WORKDIR /app

RUN pip install --no-cache-dir Cython
RUN apt-get update
RUN apt-get install --no-install-recommends -y gcc \
                       git \
                       libatlas3-base \
									libavformat58 \
                       portaudio19-dev \
									avahi-daemon \
                       pulseaudio && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip wheel setuptools
RUN pip install --no-cache-dir git+https://github.com/LedFx/LedFx@frontend_beta

RUN apt-get install --no-install-recommends -y alsa-utils && rm -rf /var/lib/apt/lists/*;
RUN adduser root pulse-access

# https://gnanesh.me/avahi-docker-non-root.html
RUN apt-get install --no-install-recommends -y libnss-mdns && rm -rf /var/lib/apt/lists/*;
RUN echo '*' > /etc/mdns.allow \
	&& sed -i "s/hosts:.*/hosts:          files mdns4 dns/g" /etc/nsswitch.conf \
	&& printf "[server]\nenable-dbus=no\n" >> /etc/avahi/avahi-daemon.conf \
	&& chmod 777 /etc/avahi/avahi-daemon.conf \
	&& mkdir -p /var/run/avahi-daemon \
	&& chown avahi:avahi /var/run/avahi-daemon \
	&& chmod 777 /var/run/avahi-daemon

RUN apt-get install --no-install-recommends -y wget \
                       libavahi-client3 \
                       libavahi-common3 \
                       apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y squeezelite && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y snapclient && rm -rf /var/lib/apt/lists/*;

COPY setup-files/ /app/
RUN chmod a+wrx /app/*

ENTRYPOINT ./entrypoint.sh
