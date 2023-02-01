FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git make gcc && rm -rf /var/lib/apt/lists/*;
COPY . /opt/gimsatul
WORKDIR /opt/gimsatul
#RUN ./configure --quiet && make test
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make test
ENTRYPOINT ["./run-in-docker.sh"]
