FROM ubuntu:15.10
MAINTAINER lucas@vanlierop.org
ENV LANG C.UTF-8

# Install Haskell
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y haskell-platform && rm -rf /var/lib/apt/lists/*;

# Create working dir
RUN mkdir -p /var/app
COPY . /var/app
WORKDIR /var/app

# Run raffler
CMD ["/var/app/run.sh"]
