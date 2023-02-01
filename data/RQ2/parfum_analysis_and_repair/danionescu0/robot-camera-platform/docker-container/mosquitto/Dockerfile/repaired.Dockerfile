FROM resin/rpi-raspbian:jessie-20180109

RUN apt-get update && apt-get install --no-install-recommends apt-transport-https ca-certificates -y wget && rm -rf /var/lib/apt/lists/*;

RUN wget -q -O - https://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mosquitto-jessie.list https://repo.mosquitto.org/debian/mosquitto-jessie.list
RUN apt-get update && apt-get install --no-install-recommends -y mosquitto && rm -rf /var/lib/apt/lists/*;

RUN adduser --system --disabled-password --disabled-login mosquitto
COPY ./mosquitto.conf /etc/mosquitto/mosquitto.conf
RUN echo "" > /etc/mosquitto/pwfile
RUN mosquitto_passwd -b /etc/mosquitto/pwfile user your_password

EXPOSE 1883

CMD /usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf