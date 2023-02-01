FROM dymaxionlabs/qgis-testing-environment:qgis-2.18
MAINTAINER Damián Silvani <munshkr@gmail.com>

ADD requirements.txt /tmp/
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive \
  pip --no-cache-dir \
  install -r /tmp/requirements.txt

ENV PYTHONPATH /usr/share/qgis/python/plugins:$PYTHONPATH
