# Dockerfile to build container for unit testing

FROM debian:stable

RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ant && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y jblas && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

ADD . ./

RUN rm lib/jblas-1.2.4.jar
RUN ln -s /usr/share/java/jblas.jar lib/jblas.jar

ENTRYPOINT ant test
