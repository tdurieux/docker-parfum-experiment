# NodeJS GulpJS Ruby (gewo/ngr)
FROM gewo/ruby
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

RUN apt-get update && \
  apt-get -y --no-install-recommends install software-properties-common curl git && rm -rf /var/lib/apt/lists/*;

# Install NodeJS
RUN add-apt-repository ppa:chris-lea/node.js && \
  apt-get update && \
  sudo apt-get -y --no-install-recommends install nodejs && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN npm install -g gulp && npm cache clean --force;

CMD ["/bin/bash"]
