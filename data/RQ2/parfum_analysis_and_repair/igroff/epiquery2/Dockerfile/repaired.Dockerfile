from node:5.5.0

RUN apt-get update
RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends bc && rm -rf /var/lib/apt/lists/*;

# Add Docker Client
RUN apt-get -y --no-install-recommends install apt-transport-https ca-certificates curl gnupg2 software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;

RUN npm install -g igroff/difftest-runner && npm cache clean --force;
RUN npm install -g coffee-script && npm cache clean --force;

RUN mkdir /var/app
WORKDIR /var/app
ADD . /var/app


RUN make build

#ENTRYPOINT ["/bin/bash"]
CMD ["./epistream.coffee"]
