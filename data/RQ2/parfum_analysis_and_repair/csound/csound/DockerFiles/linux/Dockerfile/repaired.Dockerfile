#specify the base OS
From ubuntu:latest

#Running apt updates on OS
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list

RUN apt-get update -y

#RUN apt-get upgrade -y


#Running installations on the os

RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends cmake -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends vim -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get build-dep csound -y


#Running build commands once container starts

CMD git clone https://github.com/csound/csound.git && mkdir cs6make && cd cs6make && cmake ../csound && make -j6 && make install


ENV DEBIAN_FRONTEND teletype