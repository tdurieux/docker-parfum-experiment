FROM ubuntu:20.04

# install tzdata first to prevent 'geographic area' prompt
RUN apt-get update >/dev/null \
	&& apt-get install --no-install-recommends -y tzdata \
	&& apt-get install --no-install-recommends -y git curl && rm -rf /var/lib/apt/lists/*;

# mongodb
RUN apt-get install --no-install-recommends -y wget gnupg \
	&& wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - \
	&& echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" \
	| tee /etc/apt/sources.list.d/mongodb-org-5.0.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y mongodb-org && rm -rf /var/lib/apt/lists/*;

# nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
	&& apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# rest dependencies
RUN apt-get install --no-install-recommends -y make gcc g++ && rm -rf /var/lib/apt/lists/*;

# install python
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

# install shellcheck and gitlint
RUN apt-get install --no-install-recommends -y shellcheck \
	&& pip install --no-cache-dir gitlint && rm -rf /var/lib/apt/lists/*;

# codecov uploader
RUN curl -f -Os https://uploader.codecov.io/v0.1.20/linux/codecov \
	&& chmod +x codecov \
	&& mv codecov /usr/local/bin

# add ubuntu user (used by jenkins)
RUN useradd --uid 1000 -ms /bin/bash ubuntu

# Create the MongoDB data directory
RUN mkdir -p /data/db \
	&& chown -R ubuntu:ubuntu /data

WORKDIR /home/ubuntu
