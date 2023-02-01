FROM debian:buster-slim
MAINTAINER Giuseppe De Marco <demarcog83@gmail.com>

RUN apt update && apt install --no-install-recommends -y libffi-dev libssl-dev python3-pip libpcre3 libpcre3-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir uwsgi
ENV BASEDIR=/satosa_statics/
WORKDIR $BASEDIR
ENTRYPOINT uwsgi --uid 1000 --https 0.0.0.0:9999,/satosa_pki/cert.pem,/satosa_pki/privkey.pem --check-static-docroot --check-static $BASEDIR --static-index disco.html
