FROM omab/pyenv-tox
MAINTAINER Matías Aguirre <matiasaguirre@gmail.com>
RUN apt-get update
RUN apt-get install -y make libxml2-dev libxmlsec1-dev pkg-config
