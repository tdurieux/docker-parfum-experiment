FROM ubuntu:20.04

# install dependencies (install tzdata first to prevent 'geographic area' prompt)
RUN apt-get update \
	&& apt-get install --no-install-recommends -y tzdata \
	&& apt-get install --no-install-recommends -y openjdk-11-jdk-headless git curl libssl-dev maven ca-certificates \
	&& update-ca-certificates && rm -rf /var/lib/apt/lists/*;

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

WORKDIR /home/ubuntu
