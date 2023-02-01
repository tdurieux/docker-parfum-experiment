FROM postgres:9
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	clang \
	libpython2.7-dev \
	python2.7-dev \
	postgresql-client-9.6 \
	postgresql-server-dev-9.6 \
	postgresql-plpython-9.6 \
	python-setuptools && rm -rf /var/lib/apt/lists/*;

ENV PGUSER postgres
ENV LC_ALL C.UTF-8
