FROM selenium/standalone-chrome
MAINTAINER <Orange Tsai> orange@chroot.org

EXPOSE 8000/tcp

USER root

RUN apt update && apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir selenium flask pillow flask flask-limiter

COPY app/                 /app
COPY files/secret           /secret
COPY files/read_secret       /read_secret
COPY files/entrypoint.sh  /

WORKDIR /app/
CMD ["/entrypoint.sh"]