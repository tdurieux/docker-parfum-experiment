FROM ubuntu

RUN sudo apt-get update
RUN sudo sudo apt-get install --no-install-recommends -y python-software-properties software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN sudo add-apt-repository ppa:chris-lea/node.js
RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends -y python g++ make nodejs && rm -rf /var/lib/apt/lists/*;
RUN sudo npm install -g hipcheck && npm cache clean --force;

VOLUME [~/.hipcheck, /.hipcheck]

CMD hipcheck --help