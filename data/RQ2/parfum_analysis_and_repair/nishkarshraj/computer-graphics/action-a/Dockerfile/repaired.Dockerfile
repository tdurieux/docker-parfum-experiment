FROM ubuntu
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install freeglut3-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /nish
WORKDIR /nish
ADD script1.sh /nish/script1.sh
ADD Hut.cpp /nish/Hut.cpp
RUN pwd
RUN ls
RUN chmod +x /nish/script1.sh
CMD /nish/script1.sh
