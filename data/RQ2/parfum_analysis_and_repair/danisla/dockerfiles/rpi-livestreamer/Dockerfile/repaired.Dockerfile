FROM danisla/rpi-omxplayer
MAINTAINER "Dan Isla <dan.isla@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    python-pip rtmpdump \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir livestreamer

WORKDIR /usr/local/bin

COPY start.sh ./
RUN chmod +x start.sh

ENTRYPOINT ["start.sh"]
