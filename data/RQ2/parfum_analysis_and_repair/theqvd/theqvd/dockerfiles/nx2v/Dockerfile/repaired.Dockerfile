FROM debian:9.5

RUN apt-get update && apt-get install --no-install-recommends -y curl wget x11-xserver-utils x11vnc xvfb xinit && rm -rf /var/lib/apt/lists/*;

COPY ["nx2v.pl", "/usr/bin/nx2v"]
RUN chmod 777 /usr/bin/nx2v

RUN ["wget", "-q", "-O", "/usr/bin/qvdclient", "http://theqvd.com/downloads/binaries/linux/qvdclient_x86_64"]
RUN chmod 777 /usr/bin/qvdclient

EXPOSE 5900

ENTRYPOINT ["perl", "/usr/bin/nx2v"]
