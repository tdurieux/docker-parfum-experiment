# local develoment image
FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y jq wget && rm -rf /var/lib/apt/lists/*;
RUN wget -c https://github.com/caddyserver/caddy/releases/download/v2.4.3/caddy_2.4.3_linux_amd64.deb -O /tmp/caddy.deb && dpkg -i /tmp/caddy.deb

WORKDIR /app
# make sure binary ontology in root of current repo
COPY ontology ontology
COPY docker/start.sh start.sh
COPY docker/config.json config.json


EXPOSE 20334 20335 20336 20337 20338 20339
#NOTE! we highly recommand that you put data dir to a mounted volume, e.g. --data-dir /data/Chain
#write data to docker image is *not* a best practice
CMD ["/app/start.sh"]
