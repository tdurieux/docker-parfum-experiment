FROM ubuntu:20.04

RUN apt-get update -y && \
 apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /requirements.txt

WORKDIR /

RUN pip3 install --no-cache-dir -r requirements.txt && \
mkdir /config && mkdir /deemix && mkdir /downloads && mkdir /import && \
mkdir /root/.config && \
ln -s /config /root/.config/deemon && \
ln -s /deemix /root/.config/deemix

COPY deemon /app/deemon

ENV PYTHONPATH="$PYTHONPATH:/app"

VOLUME /config /downloads /import /deemix
