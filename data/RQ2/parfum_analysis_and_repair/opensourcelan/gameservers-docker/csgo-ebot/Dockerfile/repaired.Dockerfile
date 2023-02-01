FROM csgo

USER root

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;


WORKDIR /steam/csgo/

ADD download.sh /tmp/download.sh
RUN /tmp/download.sh


ADD start.sh /steam/csgo/start.sh
USER root
#ADD cfg csgo/cfg
#RUN chown  -R steam:steam csgo/cfg/
USER steam
