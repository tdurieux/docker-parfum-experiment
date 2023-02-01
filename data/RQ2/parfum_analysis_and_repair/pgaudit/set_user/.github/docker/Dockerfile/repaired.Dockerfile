# set_user Docker image
# This image is used for testing the set_user build process
ARG PGVER
FROM postgres:${PGVER}
ARG PGVER
ARG DEVPKG
COPY . /src/set_user
WORKDIR /src/set_user
RUN apt-get update && \
	apt-get -y upgrade && \
	apt-get -y --no-install-recommends install postgresql-server-dev-${DEVPKG} make gcc && rm -rf /var/lib/apt/lists/*;
RUN make USE_PGXS=1 install