FROM      ubuntu
MAINTAINER Politecnico di Torino

RUN apt-get update
RUN apt-get install --no-install-recommends -y libpcap-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential cmake && rm -rf /var/lib/apt/lists/*;

RUN mkdir example
ADD example.c example/example.c
ADD CMakeLists.txt example/CMakeLists.txt
#RUN gcc example.c -lpcap -o example
RUN cd example && cmake . && make

CMD ./example/example
