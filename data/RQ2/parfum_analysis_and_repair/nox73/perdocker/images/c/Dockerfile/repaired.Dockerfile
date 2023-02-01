# Perdocker
#
# VERSION               0.0.1

FROM      ubuntu
MAINTAINER Nox73

# make sure the package repository is up to date
RUN apt-get install --no-install-recommends -y gcc g++ && rm -rf /var/lib/apt/lists/*;

RUN groupadd perdocker
RUN useradd -g perdocker perdocker

USER perdocker
