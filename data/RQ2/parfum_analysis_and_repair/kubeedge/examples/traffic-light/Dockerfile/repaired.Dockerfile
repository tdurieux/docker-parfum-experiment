FROM ubuntu:19.04
RUN apt-get update && apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://project-downloads.drogon.net/wiringpi-latest.deb && dpkg -i wiringpi-latest.deb
RUN mkdir -p /traffic
COPY ./light /traffic/
WORKDIR  traffic
