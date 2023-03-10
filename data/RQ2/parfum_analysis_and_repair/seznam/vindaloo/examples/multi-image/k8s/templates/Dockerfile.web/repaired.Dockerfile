{{#includes}}{{&base_image}}{{/includes}}
LABEL maintainer="{{{maintainer}}}"
LABEL description="avengers web"

EXPOSE 8000
ENV prometheus_multiproc_dir=/srv/http/web/log/prometheus

RUN apt-get install --no-install-recommends -y \
        uwsgi \
        uwsgi-core \
        uwsgi-plugin-python && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /srv/http/web
COPY web/Pipfile web/Pipfile.lock /srv/http/web/
RUN cd /srv/http/web && https_proxy={{https_proxy}} pipenv install --system --deploy

RUN groupadd -r --gid=1000 avengers-web && \
    useradd -r --uid=1000 -b /srv/http/web -d /srv/http/web -m -s /bin/bash -g avengers-web avengers-web

COPY web /srv/http/web
RUN chown -R avengers-web:avengers-web /srv/http/web
ENV USER="avengers-web"

ENTRYPOINT ["uwsgi", "/srv/http/web/conf/uwsgi.ini"]
LABEL version="{{version}}"
