FROM python:3.10.0

RUN apt update && apt install --no-install-recommends git nginx libnginx-mod-rtmp ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /archive && mkdir /hls
RUN chown -R www-data:root /archive /hls

COPY ./docker/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/startup.sh /startup.sh
RUN chmod +x /startup.sh

WORKDIR /app
# RUN git clone https://github.com/GOATS2K/overpass.git .
COPY . .
RUN pip3 install --no-cache-dir .

EXPOSE 8000
EXPOSE 1935

CMD ["/startup.sh"]
