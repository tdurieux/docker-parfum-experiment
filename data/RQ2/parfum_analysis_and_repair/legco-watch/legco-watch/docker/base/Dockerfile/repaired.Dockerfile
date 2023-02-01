FROM debian:7.7

# Some base commands to set up the image for interactive use
RUN apt-get update && apt-get -y --no-install-recommends install build-essential \
 python-dev \
 python-setuptools \
 python-psycopg2 \
 python-virtualenv \
 python-pip \
 libpq-dev \
 vim \
 tmux \
 htop \
 git \
 libffi-dev \
 libxml2-dev \
 libxslt1-dev \
 curl \
 abiword && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir virtualenv
RUN ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts
