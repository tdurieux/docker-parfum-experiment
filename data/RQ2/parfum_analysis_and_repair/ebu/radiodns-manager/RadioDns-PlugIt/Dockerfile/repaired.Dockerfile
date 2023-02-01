FROM python:2.7-jessie
MAINTAINER Ioannis Noukakis <inoukakis@gmail.com>

SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install --no-install-recommends uwsgi-plugin-python build-essential python-dev libmysqlclient-dev -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt/app/
COPY . /opt/app/
RUN virtualenv venv && \
    source venv/bin/activate && \
    pip install --no-cache-dir . && \
    useradd -ms /bin/bash uwsgi && \
    chown -R uwsgi /usr/lib/python2.7 && \
    chown -R uwsgi /opt
USER uwsgi
ENTRYPOINT ["uwsgi"]
CMD ["radio-dns-plugit.ini"]