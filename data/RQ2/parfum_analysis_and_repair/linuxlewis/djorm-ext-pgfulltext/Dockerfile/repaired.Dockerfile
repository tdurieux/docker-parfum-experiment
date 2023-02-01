FROM ubuntu:14.04

MAINTAINER Rémy Greinhofer <remy.greinhofer@livelovely.com>

# Create the directory containing the code.
RUN mkdir /code
WORKDIR /code

# Set the environment variables.
ENV PYTHONPATH $PYTHONPATH:/code

# Update the package list.
RUN apt-get update \

  # Install libgeos. \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \

    git \

  # Install Python2.x.
    python \
    python-dev \
    python-pip \

  # Install Python3.
    python3 \
    python3-dev \
    python3-pip \

  # Install postgresql dev lib.
    libpq-dev \

  # Cleaning up.
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy the requirements.txt file.
COPY requirements.txt /code/requirements.txt
COPY test-requirements.txt /code/test-requirements.txt

# Install the pip packages.
RUN pip install --no-cache-dir -q -r requirements.txt -r
RUN pip3 install --no-cache-dir -q -r requirements.txt -r
