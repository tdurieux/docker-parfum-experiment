FROM python:3

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt install --no-install-recommends -y nginx \
  && pip3 install --no-cache-dir gunicorn flask pycrypto supervisor \
  && useradd -m app && rm -rf /var/lib/apt/lists/*;

COPY supervisord.conf /supervisord.conf
COPY server/ /server
RUN "/server/setup.sh"

RUN chmod -w -R /server

CMD ["supervisord", "-c", "/supervisord.conf"]
