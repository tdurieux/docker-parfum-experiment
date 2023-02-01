FROM ubuntu:trusty
RUN apt-get update
RUN apt-get install --no-install-recommends wget curl zip python python-requests python-lxml git -y && rm -rf /var/lib/apt/lists/*;
RUN wget -O- https://neuro.debian.net/lists/trusty.us-nh.full | tee /etc/apt/sources.list.d/neurodebian.sources.list
RUN apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9
RUN apt-get update
RUN apt-get install --no-install-recommends fsl -y -q && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /nrgpackages/tools.release
RUN ln -s /nrgpackages/tools.release tools
RUN cd /nrgpackages/tools.release; git clone https://bitbucket.org/hodgem/intradb_docker_scripts intradb; cd /;
