FROM python:3.5-stretch
MAINTAINER Ioannis Noukakis <inoukakis@gmail.com>

SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install --no-install-recommends uwsgi-plugin-python3 build-essential libjpeg-dev zlib1g-dev virtualenv -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt/app/
COPY . /opt/app/
RUN virtualenv --python=$(which python3) venv && \
    source venv/bin/activate && \
    pip install --no-cache-dir . && \
    useradd -ms /bin/bash uwsgi && \
    chown -R uwsgi /usr/local/bin/python3 && \
    chown -R uwsgi /opt

USER uwsgi
CMD ["./runserver.sh"]
