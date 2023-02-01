FROM lyft/imagebase:d73781c2355e7b4dd3f04e9bf95a15c40761b359
RUN : \
    && apt-get update -y \
    && apt-get install -y \
        iptables \
        python-virtualenv
ENV PATH=/venv/bin:$PATH
COPY requirements.txt requirements_wsgi.txt /code/metadataproxy/
RUN : \
    && virtualenv /venv -ppython2.7 \
    && pip install -r/code/metadataproxy/requirements_wsgi.txt \
    && pip install -r/code/metadataproxy/requirements.txt
RUN mkdir -p /etc/gunicorn
COPY gunicorn.conf /etc/gunicorn/gunicorn.conf
COPY . /code/metadataproxy/
ENV DOCKER_URL 'unix://var/run/docker_sockets/docker.sock'
