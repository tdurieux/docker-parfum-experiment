FROM ubuntu:21.10

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update -y && apt-get install --no-install-recommends -y ruby2.2 dpkg-dev && rm -rf /var/lib/apt/lists/*;

ADD ci/install.sh /

CMD [ "/install.sh" ]
