FROM themattrix/tox-base
MAINTAINER Matías Aguirre <matiasaguirre@gmail.com>
RUN apt-get update && apt-get install --no-install-recommends -y make libxml2-dev libxmlsec1-dev pkg-config && rm -rf /var/lib/apt/lists/*;
