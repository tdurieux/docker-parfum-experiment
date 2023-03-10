FROM ubuntu:14.04.1

ENV DEBIAN_FRONTEND noninteractive

run apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
   build-essential \
   python-dev \
   libmysqlclient-dev \
   python-pkg-resources \
   python-setuptools \
   python-virtualenv \
   python-pip \
   libpq5 \
   libpq-dev \
   wget \
   language-pack-en-base \
   uuid-dev \
   git-core \
   mysql-client-5.5 && rm -rf /var/lib/apt/lists/*;

run locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

# Setup pypy
run mkdir /src
workdir /src
run wget https://bitbucket.org/pypy/pypy/downloads/pypy2-v5.4.0-linux64.tar.bz2 --no-check-certificate
run bunzip2 pypy2-v5.4.0-linux64.tar.bz2
run tar xvf pypy2-v5.4.0-linux64.tar && rm pypy2-v5.4.0-linux64.tar
ENV PATH $PATH:/src/pypy2-v5.4.0-linux64/bin/
run wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate
run pypy get-pip.py

run ln -s /usr/bin/gcc /usr/local/bin/cc

# Use https://github.com/Yelp/dumb-init to make sure signals propogate
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64
RUN chmod +x /usr/local/bin/dumb-init

# Add the service code
WORKDIR /code
ADD     requirements.txt /code/requirements.txt
ADD     setup.py /code/setup.py
RUN     virtualenv -p pypy /code/virtualenv_run
RUN     /code/virtualenv_run/bin/pip install \
            -i https://pypi.yelpcorp.com/simple/ \
            -r /code/requirements.txt

ADD     . /code

RUN useradd batch
RUN chown -R batch /code

USER batch

# Share the logging directory as a volume
RUN     mkdir /tmp/logs
VOLUME  /tmp/logs

WORKDIR /code
ENV     BASEPATH /code
CMD ["/usr/local/bin/dumb-init", "/code/virtualenv_run/bin/pypy", "/code/replication_handler/batch/parse_replication_stream_internal.py", "--no-notification"]
