FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN apt-get -yq update && apt-get -yq upgrade
RUN apt-get -yq --no-install-recommends install python-software-properties software-properties-common python g++ make git && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -yq update
RUN apt-get -yq --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g hubot coffee-script && npm cache clean --force;
RUN hubot --create /usr/local/hubot
WORKDIR /usr/local/hubot
CMD ["/bin/bash"]
