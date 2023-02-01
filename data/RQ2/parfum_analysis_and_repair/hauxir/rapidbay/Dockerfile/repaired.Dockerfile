FROM hauxir/libtorrent-python3-ubuntu:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    nginx \
    zip \
    ffmpeg \
    git \
    mediainfo && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir lxml
RUN pip install --no-cache-dir pymediainfo==4.2.1
RUN pip install --no-cache-dir iso-639
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir -e git+https://github.com/agonzalezro/python-opensubtitles#egg=python-opensubtitles
RUN pip install --no-cache-dir bencodepy
RUN pip install --no-cache-dir parse-torrent-name
RUN pip install --no-cache-dir python-dateutil
RUN pip install --no-cache-dir gunicorn
RUN wget https://github.com/kaegi/alass/releases/download/v2.0.0/alass-linux64 -O /usr/bin/alass
RUN chmod +x /usr/bin/alass

# BitTorrent incoming
EXPOSE 6881
EXPOSE 6881/udp

# HTTP port
EXPOSE 5000

COPY app /app
COPY nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /app

CMD bash entrypoint.sh
