ARG SLURM_VER=20.11
FROM brianmay/slurm:${SLURM_VER}
MAINTAINER brian@linuxpenguins.xyz

# Install OS dependencies
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    gcc sudo libcrack2-dev \
  && rm -rf /var/lib/apt/lists/*

# Make application directory
RUN mkdir /opt/karaage /opt/karaage/requirements
WORKDIR /opt/karaage

# Install our requirements.
RUN pip install --no-cache-dir poetry
ADD pyproject.toml poetry.lock /opt/karaage/
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev --no-root

# Copy all our files into the image.
COPY . /opt/karaage/
RUN chmod go+rX -R /opt/karaage/

# Setup access to version information
ARG VERSION=
ARG BUILD_DATE=
ARG VCS_REF=
ENV VERSION=${VERSION}
ENV BUILD_DATE=${BUILD_DATE}
ENV VCS_REF=${VCS_REF}

# Specify the command to run when the image is run.
EXPOSE 8000
VOLUME '/etc/karaage3' '/var/log' '/var/lib/karaage3'
CMD /opt/karaage/scripts/docker.sh
