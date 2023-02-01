FROM ubuntu:15.10
MAINTAINER lucas@vanlierop.org
ENV LANG C.UTF-8

# Install Cobol
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y open-cobol && rm -rf /var/lib/apt/lists/*;

# Create working dir
RUN mkdir -p /var/app
COPY . /var/app
WORKDIR /var/app

# Compile raffler
RUN /var/app/compile.sh

# Run raffler
CMD ["/var/app/run.sh"]
