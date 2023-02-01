FROM node:14 as consolebuilder
WORKDIR /app
RUN wget https://github.com/janelia-flyem/dvid-console/releases/download/v2.1.6/dvid-console-2.1.6.tar.gz
RUN tar -zxvf dvid-console-2.1.6.tar.gz && rm dvid-console-2.1.6.tar.gz


FROM ubuntu:20.04 as builder
ARG DVID_VERSION=0.9.7
MAINTAINER flyem project team
LABEL maintainer="neuprint@janelia.hhmi.org"
LABEL dvid_version=${DVID_VERSION}
LABEL console_version='2.1.6'
RUN apt-get update && apt-get install --no-install-recommends -y curl bzip2 && rm -rf /var/lib/apt/lists/*;
WORKDIR /app/
COPY --from=consolebuilder /app/dvid-console /console
RUN curl -f -L -O https://github.com/janelia-flyem/dvid/releases/download/v${DVID_VERSION}/dvid-${DVID_VERSION}-dist-linux.tar.bz2
RUN tar -jxf dvid-${DVID_VERSION}-dist-linux.tar.bz2 && rm dvid-${DVID_VERSION}-dist-linux.tar.bz2
RUN ln -s /app/dvid-${DVID_VERSION}-dist-linux/bin/dvid /usr/local/bin
COPY ./conf/config.example /conf/config.toml
CMD ["dvid", "-verbose", "serve", "/conf/config.toml"]
#CMD ["/bin/bash"]
