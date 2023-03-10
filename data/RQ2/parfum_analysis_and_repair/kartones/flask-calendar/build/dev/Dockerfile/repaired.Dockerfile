FROM flask-calendar:base

ARG uid=1000
ARG gid=1000

USER root

COPY requirements-dev.txt /code
RUN pip install --no-cache-dir -r /code/requirements-dev.txt

# --- Comment this if you don't want to change/use locales
RUN apt-get -y update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN echo 'es_ES.UTF-8 UTF-8\n' >> /etc/locale.gen
RUN locale-gen
# ---

USER $uid

VOLUME /code
WORKDIR /code
