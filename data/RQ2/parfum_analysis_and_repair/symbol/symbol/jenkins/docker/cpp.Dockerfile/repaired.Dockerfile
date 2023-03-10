FROM symbolplatform/symbol-server-build-base:ubuntu-gcc-11-conan

# install shellcheck and gitlint
RUN apt-get install --no-install-recommends -y shellcheck && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir gitlint

# mongodb
RUN apt-get install --no-install-recommends -y wget gnupg \
	&& wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - \
	&& echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" \
	| tee /etc/apt/sources.list.d/mongodb-org-5.0.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y mongodb-org && rm -rf /var/lib/apt/lists/*;

# add ubuntu user (used by jenkins)
RUN useradd --uid 1000 -ms /bin/bash ubuntu

# Create the MongoDB data directory
RUN mkdir -p /data/db \
	&& chown -R ubuntu:ubuntu /data

WORKDIR /home/ubuntu
