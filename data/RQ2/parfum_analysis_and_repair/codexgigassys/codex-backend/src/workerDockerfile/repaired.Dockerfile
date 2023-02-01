FROM python:2.7
RUN mkdir /myapp
WORKDIR /myapp
ADD . /myapp/
ENV PYTHONUNBUFFERED=0
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y build-essential \
libpq-dev \
libffi-dev \
libssl-dev \
python-dev \
libfuzzy-dev \
python-gevent \
python-pip \
python-magic \
python-crypto \
python-dateutil \
autoconf \
openssl \
file \
python \
autoconf \
automake \
libc-dev \
libtool && \
echo "Installing pip requirements" && \
 pip install --no-cache-dir -r /myapp/pip_requirements.txt && \
 pip install --no-cache-dir -r /myapp/pip_vt_api_requirements.txt && rm -rf /var/lib/apt/lists/*;
CMD ["/usr/local/bin/rq","worker", "-u", "redis://codexbackend_redis_1:6379/0", "task"]
