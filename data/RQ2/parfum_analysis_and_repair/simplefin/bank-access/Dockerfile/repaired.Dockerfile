# Copyright (c) The SimpleFIN Team
# See LICENSE for details.

FROM ubuntu:14.04
MAINTAINER iffy

# system deps
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# for lxml
RUN apt-get install --no-install-recommends -y libz-dev libxml2-dev libxslt1-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip

#------------------------------------------------------------------------------
# firefox and vnc
#------------------------------------------------------------------------------
RUN apt-get update && apt-get install --no-install-recommends -y x11vnc xvfb firefox && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic && rm -rf /var/lib/apt/lists/*;

#------------------------------------------------------------------------------
# python deps
#------------------------------------------------------------------------------
WORKDIR /work
COPY requirements.txt /work/requirements.txt
RUN pip install --no-cache-dir -r /work/requirements.txt


COPY . /work
ADD dockerutil/start.sh /home/root/start.sh

#------------------------------------------------------------------------------
# Use INSECURE, shared, globally available key
#------------------------------------------------------------------------------
RUN mv util/samplekeys .gpghome


EXPOSE 80

ENTRYPOINT ["sh", "/home/root/start.sh"]
