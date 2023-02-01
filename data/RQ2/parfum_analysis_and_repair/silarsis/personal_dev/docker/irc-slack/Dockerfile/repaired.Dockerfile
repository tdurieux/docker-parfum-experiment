FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN apt-get -yq update && apt-get -yq upgrade
RUN apt-get -yq --no-install-recommends install python-software-properties software-properties-common python g++ make git && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -yq update
RUN apt-get -yq --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
#RUN git clone https://github.com/rknLA/irc-slack-echo.git
#WORKDIR /irc-slack-echo
RUN git clone https://github.com/jimmyhillis/slack-irc-plugin.git
WORKDIR /slack-irc-plugin
RUN npm install && npm cache clean --force;
RUN node .
CMD ["/bin/bash"]
