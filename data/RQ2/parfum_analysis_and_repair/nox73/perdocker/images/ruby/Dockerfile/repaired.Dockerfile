# Perdocker
#
# VERSION               0.0.1

FROM      ubuntu
MAINTAINER Nox73

# make sure the package repository is up to date
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://get.rvm.io | bash -s stable --ruby

RUN groupadd perdocker
RUN useradd -g perdocker perdocker

USER perdocker
