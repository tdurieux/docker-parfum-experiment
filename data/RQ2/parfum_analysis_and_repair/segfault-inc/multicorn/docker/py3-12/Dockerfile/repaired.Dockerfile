FROM postgres:12
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	clang \
	libpython3.7-dev \
	python3.7-dev \
	postgresql-client-12 \
	postgresql-server-dev-12 \
	python3-setuptools && rm -rf /var/lib/apt/lists/*;

ENV PGUSER postgres
ENV PYTHON_OVERRIDE python3.7
ENV LC_ALL C.UTF-8
