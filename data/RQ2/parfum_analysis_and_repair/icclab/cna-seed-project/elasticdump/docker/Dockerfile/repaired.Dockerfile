FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:chris-lea/node.js
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install -g elasticdump && npm cache clean --force;

ADD import.sh /import.sh
ADD export.sh /export.sh

CMD /bin/bash
