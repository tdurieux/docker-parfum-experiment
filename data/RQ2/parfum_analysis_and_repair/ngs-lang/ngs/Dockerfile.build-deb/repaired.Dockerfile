FROM debian:stretch
RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
ADD . /src
WORKDIR /src
RUN cd /src && ./install.sh && make tests

RUN apt-get install --no-install-recommends -y devscripts && rm -rf /var/lib/apt/lists/*;
RUN debuild -i -us -uc -b

CMD ["/bin/bash"]