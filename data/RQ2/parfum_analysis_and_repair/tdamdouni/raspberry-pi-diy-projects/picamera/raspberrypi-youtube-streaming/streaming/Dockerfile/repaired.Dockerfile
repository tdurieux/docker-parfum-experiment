FROM ffmpeg:17-5-2017

RUN apt-get update && apt-get -qy --no-install-recommends install \
  libraspberrypi-bin && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /root/
COPY entry.sh	.
RUN chmod +x entry.sh

ENTRYPOINT ["./entry.sh"]
