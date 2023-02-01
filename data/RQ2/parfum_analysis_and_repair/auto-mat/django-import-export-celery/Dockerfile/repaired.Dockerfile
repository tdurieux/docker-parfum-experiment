FROM python:3.7
RUN pip3 install --no-cache-dir poetry celery
RUN apt-get update ; apt-get install --no-install-recommends -yq python3-psycopg2 gdal-bin && rm -rf /var/lib/apt/lists/*;
ARG UID
RUN useradd test --uid $UID
RUN chsh test -s /bin/bash
