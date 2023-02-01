FROM ubuntu:17.10

# Update
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y \
      python2.7 \
      python-pip \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install app dependencies
RUN pip install --no-cache-dir pip==9.0.1
RUN pip install --no-cache-dir virtualenv==15.1.0
