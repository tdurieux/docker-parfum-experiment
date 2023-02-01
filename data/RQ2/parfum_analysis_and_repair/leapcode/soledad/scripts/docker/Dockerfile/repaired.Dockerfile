# start with a fresh debian image
# we use backports because of libsqlcipher-dev
FROM 0xacab.org:4567/leap/docker/debian:jessie_amd64

RUN apt-get update
RUN apt-get -y dist-upgrade

# needed to build python twisted module
RUN apt-get -y install --no-install-recommends libpython2.7-dev \

  moreutils expect tcl8.6 \

  libssl-dev libffi-dev \

  libsqlcipher-dev \

  libsqlite3-dev \

  python-pip \

  curl \

  build-essential \

  docker.io \

  swaks \
  libnet-dns-perl \
  libnet-ssleay-perl && rm -rf /var/lib/apt/lists/*;

# We need git from backports because it has
# the "%cI: committer date, strict ISO 8601 format"
# pretty format which is used by pytest-benchmark
RUN apt-get -y --no-install-recommends install -t jessie-backports git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir tox
