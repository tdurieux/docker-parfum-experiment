FROM tomaslaz/sheep_base:v1 as sheep

RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get -y --no-install-recommends install python3 graphviz && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir gprof2dot
RUN apt-get -y --no-install-recommends install nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get update;

ADD applications SHEEP/backend/applications
ADD cmake SHEEP/backend/cmake
ADD CMakeLists.txt SHEEP/backend/CMakeLists.txt
ADD include SHEEP/backend/include
ADD src SHEEP/backend/src
ADD tests SHEEP/backend/tests

RUN rm -fr SHEEP/backend/build; mkdir SHEEP/backend/build

RUN cd SHEEP/backend/build; export CC=gcc-7; export CXX=g++-7; cmake ../

RUN cd SHEEP/backend/build; make

WORKDIR SHEEP/backend/build

EXPOSE 34568

# CMD ["bin/run-sheep-server"]
