FROM debian:jessie

# Add extra repositories
RUN apt-get update && apt-get install -y --no-install-recommends wget apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.6.asc | apt-key add -

RUN echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
		sudo \
		mongodb-org \
		gcc \
		make \
		g++ \
		build-essential \
		python-pip \
		python-dev \
		python3-pip \
		python3-dev && rm -rf /var/lib/apt/lists/*;

# Upgrade pip
RUN pip install --no-cache-dir --upgrade --ignore-installed pip
RUN pip3 install --no-cache-dir --upgrade --ignore-installed pip

# Put Python pip requirements files
ADD requirements.txt /tmp/requirements.txt
ADD requirements-tests.txt /tmp/requirements-tests.txt

RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements-tests.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements-tests.txt

RUN mkdir -p /data/db